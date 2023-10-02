//
//  Entries.swift
//  financialTracker
//
//  Created by Office on 02/10/2023.
//

import SwiftUI

struct Item: Identifiable{
    var id = UUID().uuidString
        var name: String
        var price: Int

        init(name: String, price: Int) {
            self.name = name
            self.price = price
        }
}

struct Store: Identifiable{
    var id = UUID().uuidString
    var name: String
    var items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
    
    var totalPrice: Int {
        let total = items.reduce(into: 0) { result, item in
            result += item.price
        }
        return total
    }
    
}
var Stores:[Store] = [
  Store(name: "Al Fateh", items: [
  Item(name: "Ice Cream", price: 650),
  Item(name: "Walnut", price: 1400),
  Item(name: "Candies", price: 100),
  ]),
  
  Store(name: "Blouch Dry Fruit", items: [
  Item(name: "Dates", price: 550)
  ]),

  Store(name: "Pan shop", items: [
  Item(name: "String", price: 80),
  Item(name: "Meetha Pan", price: 150),
  ]),
  Store(name: "Happy Toys", items: [
  Item(name: "Remote Control Car", price: 5000),
  Item(name: "Birthday Theme Pack", price: 3500),
  ]),
]


