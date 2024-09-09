import Vapor
import AMQPClient

struct MQTTClient {


    func disconnect() async throws {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        var connection: AMQPConnection
        var channel: AMQPChannel

        connection = try await AMQPConnection.connect(use: eventLoopGroup.next(), from: .init(connection: .plain, server: .init()))
        channel = try await connection.openChannel()
        try await channel.close()
        try await connection.close()
    }

    func send(to id: String, msg: ByteBuffer) async throws {

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        var connection: AMQPConnection
        var channel: AMQPChannel

        connection = try await AMQPConnection.connect(use: eventLoopGroup.next(), from: .init(connection: .plain, server: .init()))
        channel = try await connection.openChannel()

        try await channel.queueDeclare(name: id)
        try await channel.basicPublish(from: msg, exchange: "", routingKey: id)


    }

    func recive(id: String) async throws -> [Message] {

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        var connection: AMQPConnection
        var channel: AMQPChannel

        connection = try await AMQPConnection.connect(use: eventLoopGroup.next(), from: .init(connection: .plain, server: .init()))
        channel = try await connection.openChannel()
        var messages: [Message] = []
        try await channel.queueDeclare(name: id)
        while true {
            guard let frame = try await channel.basicGet(queue: id, noAck: true) else {
                print("No message currently available")
                break
            }
            let msg = try! JSONDecoder().decode(Message.self, from: frame.message.body)
            messages.append(msg)
        }
        return messages
    }
}
