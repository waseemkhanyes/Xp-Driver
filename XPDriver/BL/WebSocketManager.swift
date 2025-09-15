//
//  WebSocketManager.swift
//  XPDriver
//
//  Created by Waseem  on 21/08/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation

@objc protocol WebSocketManagerDelegate: AnyObject {
    func webSocketDidConnect()
    func webSocketDidDisconnect()
    func webSocketDidReceiveMessage(text: String?, data: [String: Any]?)
    func webSocketDidReceiveError(error: Error)
    func webSocketDidSendError(error: Error)
}


@available(iOS 13.0, *)
@objcMembers
class WebSocketManager: NSObject {
    static var shared = WebSocketManager()
    
    weak var delegate: WebSocketManagerDelegate?
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    override init() {
        super.init()
        connect()
    }
    
    func connect() {
        let url = URL(string: "ws://xpeats.com:8082")!
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        delegate?.webSocketDidConnect()
        receiveMessage()
    }
    
    func sendMessage(_ message: [String: Any]) {
        guard let webSocketTask else {
            connect()
            sendMessage(message)
            return
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let wsMessage = URLSessionWebSocketTask.Message.string(jsonString)
                webSocketTask.send(wsMessage) { error in
                    if let error = error {
                        print("WebSocket send error: \(error)")
                        self.delegate?.webSocketDidSendError(error: error)
                    } else {
//                        print("** wk message sent")
                    }
                }
            }
        } catch {
            print("Failed to serialize JSON: \(error)")
        }
    }
    
    func receiveMessage() {
        guard let webSocketTask else {
            connect()
            return
        }
        
        webSocketTask.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure(let error):
//                print("** wk WebSocket receive error: \(error)")
                self.delegate?.webSocketDidReceiveError(error: error)
            case .success(let message):
//                print("** wk Received data message: \(message)")
                switch message {
                case .string(let text):
                    if let dicData = stringToDictionary(text) {
                        print("** wk Received data message1: \(dicData)")
                        self.delegate?.webSocketDidReceiveMessage(text: nil, data: dicData)
                    }
                case .data(let data):
                    print("** wk Received data: \(data)")
                @unknown default:
                    fatalError()
                }
                self.receiveMessage() // Continue receiving messages
            }
        }
    }
    
    func disconnect() {
        print("** wk disconnect")
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        delegate?.webSocketDidDisconnect()
    }
    
    private func dataToDictionary(_ data: Data) -> [String: Any]? {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return dictionary
            }
        } catch {
            print("Failed to convert Data to dictionary: \(error)")
        }
        return nil
    }
    
    private func stringToDictionary(_ text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return dictionary
                }
            } catch {
                print("Failed to convert string to dictionary: \(error)")
            }
        }
        return nil
    }
}
