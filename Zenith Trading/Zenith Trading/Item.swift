//
//  Item.swift
//  Zenith Trading
//
//  Created by Samyack on 27/05/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
