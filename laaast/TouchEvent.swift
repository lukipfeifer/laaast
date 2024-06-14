//
//  TouchEvent.swift
//  laaast
//
//  Created by Matthias Meissen on 14.06.24.
//

import Foundation
import CoreGraphics

struct TouchEvent: Identifiable {
    let id = UUID()
    let timestamp: Date
    let position: CGPoint
}
