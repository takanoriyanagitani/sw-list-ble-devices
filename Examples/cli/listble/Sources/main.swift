import class AsyncAlgorithms.AsyncChannel
import class Foundation.ProcessInfo
import struct Foundation.UUID
import class ListBleDevices.Scanner

@main
struct ListBle {
  static func main() async {
    let env: [String: String] = ProcessInfo.processInfo.environment
    let stimeout: String = env["ENV_TIMEOUT_SECONDS"] ?? "10"
    let itimeout: UInt64 = UInt64(stimeout) ?? 10
    let ns: UInt64 = itimeout * 1_000 * 1_000 * 1_000

    print("scanning... timeout: \( itimeout ) seconds")

    let s: Scanner = Scanner()
    try? await Task.sleep(nanoseconds: ns)

    let id2name: [UUID: String] = s.getIdMap()

    for (id, name) in id2name {
      print("\( id ): \( name )")
    }
  }
}
