// See LICENSE for license details.

package lowrisc_chip

import Chisel._
import junctions._
import open_soc_debug._
import uncore._
import rocket._
import rocket.Util._
import scala.math.max
import cde.{Parameters, Config, Dump, Knob, CDEMatchError}

case object UseHost extends Field[Boolean]
case object UseUART extends Field[Boolean]
case object UseSPI extends Field[Boolean]

class DefaultConfig extends Config (
  topDefinitions = { (pname,site,here) => 
    type PF = PartialFunction[Any,Any]
    def findBy(sname:Any):Any = here[PF](site[Any](sname))(pname)

    lazy val internalIOAddrMap: AddrMap = {
      val entries = collection.mutable.ArrayBuffer[AddrMapEntry]()
      entries += AddrMapEntry("bootrom", MemSize(1<<13, 1<<12, MemAttr(AddrMapProt.RX)))
      entries += AddrMapEntry("rtc", MemSize(1<<12, 1<<12, MemAttr(AddrMapProt.RW)))
      for (i <- 0 until site(NTiles))
        entries += AddrMapEntry(s"prci$i", MemSize(1<<12, 1<<12, MemAttr(AddrMapProt.RW)))
      new AddrMap(entries)
    }

    lazy val externalIOAddrMap: AddrMap = {
      val entries = collection.mutable.ArrayBuffer[AddrMapEntry]()
      if (site(UseHost)) {
        entries += AddrMapEntry("host", MemSize(1<<6, 1<<12, MemAttr(AddrMapProt.W)))
        Dump("ADD_HOST", true)
      }
      if (site(UseUART)) {
        entries += AddrMapEntry("uart", MemSize(1<<12, 1<<12, MemAttr(AddrMapProt.RW)))
        Dump("ADD_UART", true)
      }
      if (site(UseSPI)) {
        entries += AddrMapEntry("spi", MemSize(1<<12, 1<<12, MemAttr(AddrMapProt.RW)))
        Dump("ADD_SPI", true)
      }
      new AddrMap(entries)
    }

    lazy val (globalAddrMap, globalAddrHashMap) = {
      val memSize = 1L << 31
      val memAlign = 1L << 30
      val io = AddrMap(
        AddrMapEntry("int", MemSubmap(internalIOAddrMap.computeSize, internalIOAddrMap)),
        AddrMapEntry("ext", MemSubmap(externalIOAddrMap.computeSize, externalIOAddrMap, true)))
      val addrMap = AddrMap(
        AddrMapEntry("io", MemSubmap(io.computeSize, io)),
        AddrMapEntry("mem", MemSize(memSize, memAlign, MemAttr(AddrMapProt.RWX, true))))

      val addrHashMap = new AddrHashMap(addrMap)
      Dump("MEM_BASE", addrHashMap("mem").start)
      Dump("MEM_SIZE", memSize)
      Dump("IO_BASE", addrHashMap("io:ext").start)
      Dump("IO_SIZE", addrHashMap("io:ext").region.size)
      (addrMap, addrHashMap)
    }

    // content of the device tree ROM, core and CSR
    def makeConfigString() = {
      val addrMap = globalAddrHashMap
      val xLen = site(XLen)
      val res = new StringBuilder
      res append  "platform {\n"
      res append  "  vendor lowRISC;\n"
      res append  "  arch rocket;\n"
      res append  "};\n"
      res append  "rtc {\n"
      res append s"  addr 0x${addrMap("io:int:rtc").start.toString(16)};\n"
      res append  "};\n"
      res append  "ram {\n"
      res append  "  0 {\n"
      res append s"    addr 0x${addrMap("mem").start.toString(16)};\n"
      res append s"    size 0x${addrMap("mem").region.size.toString(16)};\n"
      res append  "  };\n"
      res append  "};\n"
      res append  "core {\n"
      for (i <- 0 until site(NTiles)) {
        val isa = s"rv${site(XLen)}ima${if (site(UseFPU)) "fd" else ""}"
        val timecmpAddr = addrMap("io:int:rtc").start + 8*(i+1)
        val prciAddr = addrMap(s"io:int:prci$i").start
        res append s"  $i {\n"
        res append  "    0 {\n"
        res append s"      isa $isa;\n"
        res append s"      timecmp 0x${timecmpAddr.toString(16)};\n"
        res append s"      ipi 0x${prciAddr.toString(16)};\n"
        res append  "    };\n"
        res append  "  };\n"
      }
      res append  "};\n"
      res append '\u0000'
      res.toString.getBytes
    }

    // parameter definitions
    pname match {
      //Memory Parameters
      case CacheBlockBytes => 64
      case CacheBlockOffsetBits => log2Up(here(CacheBlockBytes))
      case PAddrBits => Dump("PADDR_WIDTH", 32)
      case PgIdxBits => 12
      case PgLevels => if (site(XLen) == 64) 3 /* Sv39 */ else 2 /* Sv32 */
      case PgLevelBits => site(PgIdxBits) - log2Up(site(XLen)/8)
      case VPNBits => site(PgLevels) * site(PgLevelBits)
      case PPNBits => site(PAddrBits) - site(PgIdxBits)
      case VAddrBits => site(VPNBits) + site(PgIdxBits)
      case ASIdBits => 7
      case MIFTagBits => Dump("MEM_TAG_WIDTH", 8)
      case MIFDataBits => Dump("MEM_DAT_WIDTH", site(TLKey("TCtoMem")).dataBitsPerBeat)
      case IODataBits => Dump("IO_DAT_WIDTH", 32)   // assume 32-bit IO NASTI-Lite bus

      //Params used by all caches
      case NSets => findBy(CacheName)
      case NWays => findBy(CacheName)
      case RowBits => findBy(CacheName)
      case NTLBEntries => findBy(CacheName)
      case CacheIdBits => findBy(CacheName)
      case SplitMetadata => findBy(CacheName)
      case ICacheBufferWays => Knob("L1I_BUFFER_WAYS")

      //L1 I$
      case BtbKey => BtbParameters()
      case "L1I" => {
        case NSets => Knob("L1I_SETS")
        case NWays => Knob("L1I_WAYS")
        case RowBits => 4*site(CoreInstBits)
        case NTLBEntries => 8
        case CacheIdBits => 0
	    case SplitMetadata => false
      }:PF

      //L1 D$
      case StoreDataQueueDepth => 17
      case ReplayQueueDepth => 16
      case NMSHRs => Knob("L1D_MSHRS")
      case LRSCCycles => 32 
      case "L1D" => {
        case NSets => Knob("L1D_SETS")
        case NWays => Knob("L1D_WAYS")
        case RowBits => 2*site(CoreDataBits)
        case NTLBEntries => 8
        case CacheIdBits => 0
	    case SplitMetadata => false
      }:PF
      case ECCCode => None
      case Replacer => () => new RandomReplacement(site(NWays))
      case AmoAluOperandBits => site(XLen)
      case WordBits => site(XLen)

      //L2 $
      case NAcquireTransactors => Knob("L2_XACTORS")
      case NSecondaryMisses => 4
      case L2DirectoryRepresentation => new FullRepresentation(site(NTiles))
      case L2Replacer => () => new SeqRandom(site(NWays))
      case "L2Bank" => {
        case NSets => Knob("L2_SETS")
        case NWays => Knob("L2_WAYS")
        case RowBits => site(TLKey(site(TLId))).dataBitsPerBeat
        case CacheIdBits => log2Ceil(site(NBanks))
	    case SplitMetadata => false
      }: PF

      // Tag Cache
      case TagBits => 4
      case TCBlockBits => site(MIFDataBits)
      case TCTransactors => Knob("TC_XACTORS")
      case TCBlockTags => 1 << log2Down(site(TCBlockBits) / site(TagBits))
      case TCBaseAddr => Knob("TC_BASE_ADDR")
      case "TagCache" => {
        case NSets => Knob("TC_SETS")
        case NWays => Knob("TC_WAYS")
        case RowBits => site(TCBlockTags) * site(TagBits)
        case CacheIdBits => 0
      }: PF
      
      //Tile Constants
      case NTiles => Knob("NTILES")
      case BuildRoCC => Nil
      case RoccNMemChannels => site(BuildRoCC).map(_.nMemChannels).foldLeft(0)(_ + _)
      case RoccNPTWPorts => site(BuildRoCC).map(_.nPTWPorts).foldLeft(0)(_ + _)
      case RoccNCSRs => site(BuildRoCC).map(_.csrs.size).foldLeft(0)(_ + _)
      case UseDma => false
      case NDmaTransactors => 3
      case NDmaXacts => site(NDmaTransactors) * site(NTiles)
      case NDmaClients => site(NTiles)

      //Rocket Core Constants
      case FetchWidth => 1
      case RetireWidth => 1
      case UseVM => true
      case UsePerfCounters => true
      case FastLoadWord => true
      case FastLoadByte => false
      case FastMulDiv => true
      case XLen => 64
      case NSCR => 64
      case UseFPU => true
      case FDivSqrt => true
      case SFMALatency => 2
      case DFMALatency => 3
      case CoreInstBits => 32
      case CoreDataBits => site(XLen)
      case NCustomMRWCSRs => 0
      case ResetVector => BigInt(0x0)
      case MtvecInit => BigInt(0x8)
      case MtvecWritable => false

      //Uncore Paramters
      case RTCPeriod => 100 // gives 10 MHz RTC assuming 1 GHz uncore clock
      case NBanks => Knob("NBANKS")
      case BankIdLSB => 0
      case LNEndpoints => site(TLKey(site(TLId))).nManagers + site(TLKey(site(TLId))).nClients
      case LNHeaderBits => log2Up(max(site(TLKey(site(TLId))).nManagers,
        site(TLKey(site(TLId))).nClients))
      case SCRKey => SCRParameters(
                       nSCR = 64,
                       csrDataBits = site(XLen),
                       offsetBits = site(CacheBlockOffsetBits),
                       nCores = site(NTiles))

      case TLKey("L1toL2") =>
        TileLinkParameters(
          coherencePolicy = new MESICoherence(site(L2DirectoryRepresentation)),
          nManagers = site(NBanks) + 1,
          nCachingClients = site(NTiles),
          nCachelessClients = site(NTiles),
          maxClientXacts = site(NMSHRs),
          maxClientsPerPort = 1,
          maxManagerXacts = site(NAcquireTransactors) + 2, // acquire, release, writeback
          dataBits = site(CacheBlockBytes)*8,
          dataBeats = 4
        )
      case TLKey("L2toIO") =>
        TileLinkParameters(
          coherencePolicy = new MICoherence(new NullRepresentation(site(NBanks))),
          nManagers = 1,
          nCachingClients = 0,
          nCachelessClients = 1,
          maxClientXacts = 1,
          maxClientsPerPort = 1,
          maxManagerXacts = 1,
          dataBits = site(CacheBlockBytes)*8
        )
      case TLKey("IONet") =>
        TileLinkParameters(
          coherencePolicy = new MICoherence(new NullRepresentation(site(NBanks))),
          nManagers = 1,
          nCachingClients = 0,
          nCachelessClients = 1,
          maxClientXacts = 1,
          maxClientsPerPort = 1,
          maxManagerXacts = 1,
          dataBits = site(CacheBlockBytes)*8,
          dataBeats = site(CacheBlockBytes)*8 / site(XLen)
        )
      case TLKey("L2toTC") =>
        TileLinkParameters(
          coherencePolicy = new MEICoherence(new NullRepresentation(site(NBanks))),
          nManagers = 1,
          nCachingClients = 0,
          nCachelessClients = site(NBanks),
          maxClientXacts = site(NAcquireTransactors) + 2,
          maxClientsPerPort = 1,
          maxManagerXacts = site(TCTransactors),
          dataBits = site(CacheBlockBytes)*8,
          dataBeats = 4
        )

      case TLKey("TCtoMem") =>
        TileLinkParameters(
          coherencePolicy = new MEICoherence(new NullRepresentation(site(NBanks))),
          nManagers = 1,
          nCachingClients = 0,
          nCachelessClients = 1,
          maxClientXacts = site(TCTransactors),
          maxClientsPerPort = 1,
          maxManagerXacts = 1,
          dataBits = site(CacheBlockBytes)*8,
          dataBeats = 8
        )

      // debug
      // disabled in Default
      case DiiIOWidth => 16
      case MamIODataWidth => 16
      case MamIOAddrWidth => 39
      case MamIOBeatsBits => 14
      case UseDebug => false

      // IO devices
      case UseHost => false
      case UseUART => false
      case UseSPI => false

      // NASTI BUS parameters
      case NastiKey("nasti") =>
        NastiParameters(
          dataBits = site(MIFDataBits),
          addrBits = site(PAddrBits),
          idBits = site(MIFTagBits)
        )
      case NastiKey("lite") =>
        NastiParameters(
          dataBits = site(XLen),
          addrBits = site(PAddrBits),
          idBits = 1
        )
      
      case ConfigString => makeConfigString()
      case GlobalAddrMap => globalAddrMap
      case GlobalAddrHashMap => globalAddrHashMap
      //case _ => throw new CDEMatchError
  }},
  knobValues = {
    case "NTILES" => Dump("NTILES", 1)
    case "NBANKS" => 1

    case "L1D_MSHRS" => 2
    case "L1D_SETS" => 64
    case "L1D_WAYS" => 4

    case "L1I_SETS" => 64
    case "L1I_WAYS" => 4
    case "L1I_BUFFER_WAYS" => false

    case "L2_XACTORS" => 2
    case "L2_SETS" => 256 // 1024
    case "L2_WAYS" => 8

    case "TC_XACTORS" => 1
    case "TC_SETS" => 64
    case "TC_WAYS" => 8
    case "TC_BASE_ADDR" => 15 << 28 // 0xf000_0000
  }
)



class WithDebugConfig extends Config (
  (pname,site,here) => pname match {
    case UseDebug => Dump("ENABLE_DEBUG", true)
    case UseUART => true
    case MamIODataWidth => Dump("MAM_IO_DWIDTH", 16)
    case MamIOAddrWidth => site(PAddrBits)
    case MamIOBeatsBits => 14
    case DebugCtmID => 0
    case DebugStmID => 1
    case DebugBaseID => 8
    case DebugCtmScorBoardSize => site(NMSHRs)
    case DebugStmCsrAddr => 0x8f0 // not synced with instruction.scala
    case DebugRouterBufferSize => 4
  }
)

class DebugConfig extends Config(new WithDebugConfig ++ new DefaultConfig)

class WithHostConfig extends Config (
  (pname,site,here) => pname match {
    case UseHost => true
  }
)

class RegressionConfig extends Config(new WithHostConfig ++ new DefaultConfig)

class WithSPIConfig extends Config (
  (pname,site,here) => pname match {
    case UseSPI => true
  }
)

class WithUARTConfig extends Config (
  (pname,site,here) => pname match {
    case UseUART => true
  }
)

class FPGAConfig extends
    Config(new WithSPIConfig ++ new WithUARTConfig ++ new DefaultConfig)

class FPGADebugConfig extends
    Config(new WithSPIConfig ++ new WithDebugConfig ++ new DefaultConfig)
