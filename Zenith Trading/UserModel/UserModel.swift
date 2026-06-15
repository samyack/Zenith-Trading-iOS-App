//
//  UserModel.swift
//  Zenith Trading
//
//  Created by Samyack on 01/06/26.
//

import Foundation

struct UserModel {
    let id: String
    let name: String
    let money: Double
}


struct TradeModel: Identifiable {
    var id: String
    var coinName: String
    var type: Int
    var units: Int
    var entryPrice: Double
    var margin: Double
    var isOpen: Bool
}
