//
//  Home.swift
//  financialTracker
//
//  Created by Office on 02/10/2023.
//

import SwiftUI

class StoreData: ObservableObject {
    @Published var stores: [Store] = [
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
        // Add other stores here
    ]

    func addNewItem(storeIndex: Int, newItem: Item) {
        stores[storeIndex].items.append(newItem)
    }

    func addNewStore(_ store: Store) {
        stores.append(store)
    }
}

struct Home: View {
    @ObservedObject var storeData = StoreData()
        @State var isItemListVisible: [Bool] = []
    init() {
           // Initialize isItemListVisible based on the count of stores
           self._isItemListVisible = State(initialValue: Array(repeating: false, count: storeData.stores.count))
       }
    @State var newStoreName: String = ""
    @State var newItemName: String = ""
    @State var newItemPrice: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Home View...
            HStack(spacing: 10) {
                Text("Financial Tracker")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)

            // Form to add new stores and items
            HStack() {
                Form {
                    Section(header: Text("Add a New Store")) {
                        TextField("Store Name", text: $newStoreName)
                        Button(action: {
                            addNewStore()
                        }) {
                            Text("Add Store")
                        }
                    }
                }
                .padding(15)
            }
            .background(Color.black)

            // Existing store list
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(storeData.stores.indices, id: \.self) { index in
                    let store = storeData.stores[index]
                    StoreView(store: store, isItemListVisible: $isItemListVisible[index], storeIndex: index, storeData: storeData)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(width: getRect().width, height: getRect().height, alignment: .leading)
        .background(Color(.systemGray).ignoresSafeArea())
    }

    func addNewStore() {
        if !newStoreName.isEmpty {
            let newStore = Store(name: newStoreName, items: [])
            storeData.addNewStore(newStore)
            isItemListVisible.append(false)
            newStoreName = ""
        }
    }
}

struct StoreView: View {
    var store: Store
    @Binding var isItemListVisible: Bool
    @State private var newItemName: String = ""
    @State private var newItemPrice: String = ""
    var storeIndex: Int
    @ObservedObject var storeData: StoreData

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(store.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                Spacer()

                HStack(spacing: 12) {
                    Text("\(store.items.count) Entries")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                    Text("Rs \(store.totalPrice)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                    Image(systemName: isItemListVisible ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
            }
            .padding(12)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .background(Color.black)
            .onTapGesture {
                withAnimation {
                    isItemListVisible.toggle()
                }
            }

            if isItemListVisible {
                ItemListView(Items: store.items)
                    .padding()

                HStack() {
                    Form {
                        Section(header: Text("Add a New Item")) {
                            TextField("Item Name", text: $newItemName)
                                .padding()
                            TextField("Item Price", text: $newItemPrice)
                                .padding()
                            Button(action: {
                                addNewItem()
                            }) {
                                Text("Add Item")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(6)
                        }
                    }
                    .padding(15)
                }
                .background(Color.black)
                // Add item input fields and button
            }
        }
    }

    func addNewItem() {
        if !newItemName.isEmpty, let price = Int(newItemPrice) {
            let newItem = Item(name: newItemName, price: price)
            storeData.addNewItem(storeIndex: storeIndex, newItem: newItem)
            newItemName = ""
            newItemPrice = ""
        }
    }
}

struct ItemListView: View {
    var Items: [Item]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Array(Items.enumerated()), id: \.offset) { enumeratedItem in
                let index = enumeratedItem.offset
                let item = enumeratedItem.element

                HStack() {
                    Text("\(index + 1).")
                        .foregroundColor(.black)
                    Text(item.name)
                        .foregroundColor(.black)
                    Spacer()
                    Text("Rs \(item.price)")
                        .foregroundColor(.black)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }

            Divider().background(Color.gray)

            HStack() {
                Text("Total")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Text("Rs \(Items.map { $0.price }.reduce(0, +))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
    }
}

extension View {
    func getRect() -> CGRect {
        return NSScreen.main!.visibleFrame
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
