//
//  Element+JSON.swift
//  PeriodicTable
//
//  Created by Tong Lin on 12/21/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

extension Element {
    func populate(from dict: [String:Any]) {
        guard let number = dict["number"] as? Int16,
            let weight = dict["weight"] as? Double,
            let name = dict["name"] as? String,
            let symbol = dict["symbol"] as? String,
            let group = dict["group"] as? Int16
            else { return }
        
        self.number = number
        self.weight = weight
        self.name = name
        self.symbol = symbol
        self.group = group
        
    }
}
