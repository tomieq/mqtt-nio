import Foundation

enum MQTTConnectionEvent {
    case didConnect(isSessionPresent: Bool)
    case willDisconnect
}
