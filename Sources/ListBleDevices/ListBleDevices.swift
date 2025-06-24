import class CoreBluetooth.CBCentralManager
import protocol CoreBluetooth.CBCentralManagerDelegate
import enum CoreBluetooth.CBManagerState
import class CoreBluetooth.CBPeripheral
import enum CoreBluetooth.CBPeripheralState
import class Foundation.NSNumber
import class Foundation.NSObject
import struct Foundation.UUID

public enum ManagerState: Sendable, CustomStringConvertible {
  case unknown
  case poweredOff
  case poweredOn
  case resetting
  case unauthorized
  case unsupported

  public var description: String {
    switch self {
    case .unknown: return "UNKNOWN"
    case .poweredOff:
      return "power off"
    case .poweredOn:
      return "power on"
    case .resetting:
      return "resetting"
    case .unauthorized:
      return "unauthorized"
    case .unsupported:
      return "unsupported"
    }
  }

  public static func from(_ state: CBManagerState) -> ManagerState {
    switch state {
    case .poweredOn:
      return .poweredOn
    case .poweredOff:
      return .poweredOff
    case .resetting:
      return .resetting
    case .unauthorized:
      return .unauthorized
    case .unknown:
      return .unknown
    case .unsupported:
      return .unsupported
    @unknown default:
      return .unknown
    }
  }
}

public enum PeripheralState: Sendable, CustomStringConvertible {
  public var description: String {
    switch self {
    case .unknown: return "UNKNOWN"
    case .disconnected:
      return "disconnected"
    case .connected:
      return "connected"
    case .connecting:
      return "connecting"
    case .disconnecting:
      return "disconnecting"
    }
  }

  case unknown

  case disconnected
  case connected
  case connecting
  case disconnecting

  public static func from(_ state: CBPeripheralState) -> PeripheralState {
    switch state {
    case .disconnected:
      return .disconnected
    case .connected:
      return .connected
    case .connecting:
      return .connecting
    case .disconnecting:
      return .disconnecting
    @unknown default:
      return .unknown
    }
  }
}

public class Scanner: NSObject, CBCentralManagerDelegate {

  private var deviceNames: [String] = []
  private var mng: CBCentralManager

  private var id2name: [UUID: String] = [:]

  private let debug: Bool

  public init(enableDebug: Bool) {
    self.mng = CBCentralManager()
    self.debug = enableDebug
    super.init()
    self.mng.delegate = self
  }

  public override init() {
    self.mng = CBCentralManager()
    self.debug = false
    super.init()
    self.mng.delegate = self
  }

  public func centralManagerDidUpdateState(_ central: CBCentralManager) {
    let state: CBManagerState = central.state
    let mstate: ManagerState = .from(state)
    guard state == .poweredOn else {
      if self.debug {
        print("[Scanner] central manager did update state: \(mstate)")
      }

      return
    }

    central.scanForPeripherals(withServices: nil, options: nil)
  }

  public func centralManager(
    _ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
    advertisementData: [String: Any], rssi RSSI: NSNumber
  ) {
    if self.debug {
      print("adv data: \( advertisementData )")
      print("rssi: \( RSSI )")
      let services: [_] = peripheral.services ?? []
      print("service count: \( services.count )")

      let state: CBPeripheralState = peripheral.state
      let pstate: PeripheralState = .from(state)
      print("peripheral state: \( pstate )")

      let writableWithoutResponse: Bool = peripheral.canSendWriteWithoutResponse
      print("writable without response: \( writableWithoutResponse )")

    }
    let id: UUID = peripheral.identifier
    self.id2name[id] = peripheral.name
    let name: String = peripheral.name ?? "Unknown"
    self.deviceNames.append(name)
  }

  public func stopScan() {
    self.mng.stopScan()
  }

  public func getDeviceNames() -> [String] { self.deviceNames }

  public func uniqueDeviceNames() -> Set<String> {
    Set(self.id2name.values)
  }

  public func getIdMap() -> [UUID: String] {
    self.id2name
  }

}
