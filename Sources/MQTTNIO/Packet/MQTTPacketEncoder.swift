import Foundation
import NIO
import Logging

final class MQTTPacketEncoder: MessageToByteEncoder {
    /// See `MessageToByteEncoder`.
    typealias OutboundIn = MQTTPacket

    /// Logger to send debug messages to.
    let logger: Logger

    /// Creates a new `MQTTPacketEncoder`.
    init(logger: Logger) {
        self.logger = logger
    }
    
    /// See `MessageToByteEncoder`.
    func encode(data packet: MQTTPacket, out: inout ByteBuffer) throws {
        var packet = packet
        // serialize header
        out.writeInteger(packet.kind.value | packet.fixedHeaderData)
        
        // write size
        try out.writeMQTTVariableByteInteger(packet.data.readableBytes, "Packet size")
        
        // serialize the packet data
        out.writeBuffer(&packet.data)
        
        logger.trace("Encoded: \(packet.kind)")
    }
    
    static func size(forPacketWithDataSize dataSize: Int) -> Int {
        return MemoryLayout<MQTTPacket.Kind.IntegerLiteralType>.size +
            ByteBuffer.sizeForMQTTVariableByteInteger(dataSize) +
            dataSize
    }
}

protocol ByteBufferSerializable {
    func serialize(into buffer: inout ByteBuffer)
}
