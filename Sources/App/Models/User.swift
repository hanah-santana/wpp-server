//
//  User.swift
//
//
//  Created by Hanah Santana on 02/09/24.
//

import Vapor
import Foundation
import AMQPClient

class User {
    let id: String
    let ws: WebSocket
    var mqttClient: MQTTClient = MQTTClient()
    var isOnline: Bool = false
    init(id: String, ws: WebSocket) {
        self.id = id
        self.ws = ws
    }
}
