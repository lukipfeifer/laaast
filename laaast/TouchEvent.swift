//
//  TouchEvent.swift
//  laaast
//
//  Created by Matthias Meissen on 14.06.24.
//

import Foundation
import CoreGraphics

struct TouchEvent: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let position: CGPoint
    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case position
    }
    
    init(id: UUID = UUID(), timestamp: Date, position: CGPoint) {
        self.id = id
        self.timestamp = timestamp
        self.position = position
    }
    
    // Custom encoding for CGPoint
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(["x": position.x, "y": position.y], forKey: .position)
    }
    
    // Custom decoding for CGPoint
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        let positionDict = try container.decode([String: CGFloat].self, forKey: .position)
        position = CGPoint(x: positionDict["x"] ?? 0, y: positionDict["y"] ?? 0)
    }
}

