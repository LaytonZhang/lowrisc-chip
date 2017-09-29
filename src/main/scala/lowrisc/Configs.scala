// See LICENSE.Cambridge for license details.

package freechips.rocketchip.lowrisc

import Chisel._
import freechips.rocketchip.config.Config
import freechips.rocketchip.coreplex._
import freechips.rocketchip.devices.debug._
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.diplomacy._

class LoRCBaseConfig extends Config(new BaseCoreplexConfig().alter((site,here,up) => {
  // DTS descriptive parameters
  case DTSModel => "freechips,rocketchip-unknown"
  case DTSCompat => Nil
  // External port parameters
  case IncludeJtagDTM => false
  case JtagDTMKey => new JtagDTMKeyDefault()
  case NExtTopInterrupts => 2
  case ExtMem => MasterPortParams(
                      base = 0x80000000L,
                      size = 0x10000000L,
                      beatBytes = site(MemoryBusParams).beatBytes,
                      idBits = 4)
  case ExPeriperals => ExPeriperalsParams(
    beatBytes = 8, // only support 64-bit right now
    idBits = 8,
    slaves = Seq(
      ExSlaveParams("mmio",   Seq("simple-bus"),     0x60000000, 0x10000000, 1),
      ExSlaveParams("serial", Seq("xlnx,uart16550"), 0x70000000, 0x1000    , 1)
    ))
  case ExtIn  => SlavePortParams(beatBytes = 8, idBits = 8, sourceBits = 4)
  // Additional device Parameters
  case ErrorParams => ErrorParams(Seq(AddressSet(0x3000, 0xfff)))
}))


class LoRCDefaultConfig extends Config(new WithNBigCores(1) ++ new LoRCBaseConfig)