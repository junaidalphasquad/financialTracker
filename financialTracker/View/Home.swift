//
//  Home.swift
//  financialTracker
//
//  Created by Office on 02/10/2023.
//

import SwiftUI
struct Home: View {
    @State var isItemListVisible: [Bool] = Array(repeating: false, count: Stores.count)
    @State var newStoreName: String = ""
    @State var newItemName: String = ""
    @State var newItemPrice: String = ""
    
    var body: some View {
        VStack(spacing:0){
            // Home View...
            HStack(spacing: 10){
                Text("Financial Tracker")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

            }.padding()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            // Form to add new stores and items
            HStack(){
                Form {
                    Section(header: Text("Add a New Store")) {
                        TextField("Store Name", text: $newStoreName)
                        Button(action: {
                            addNewStore()
                        }) {
                            Text("Add Store")
                        }
                    }
                } .padding(15)
            }.background(Color.black)
              
                
            // Existing store list
                       ScrollView(.vertical, showsIndicators: false) {
                           ForEach(Stores.indices, id: \.self) { index in
                               let store = Stores[index]
                               StoreView(store: store, isItemListVisible: $isItemListVisible[index],
                                        newItemName: $newItemName,
                                         newItemPrice: $newItemPrice,
                                         addNewItem: addNewItem ,
                                         index: index
                               )
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
               Stores.append(newStore)
               isItemListVisible.append(false)
               newStoreName = ""
           }
       }
    
    func addNewItem(_ index: Int) -> Void {
        print("index",index)
           if !newItemName.isEmpty, let price = Int(newItemPrice) {
               let newItem = Item(name: newItemName, price: price)
               Stores[index].items.append(newItem)
               isItemListVisible.append(true)
               newItemName = ""
               newItemPrice = ""
           }
       }
}

struct StoreView: View {
    var store: Store
      @Binding var isItemListVisible: Bool
      @Binding var newItemName: String
      @Binding var newItemPrice: String
    var addNewItem: (Int) -> Void
    var index: Int

    
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
                            
                            HStack(){
                                Form {
                                    Section(header: Text("Add a New Item")) {
                                        TextField("Item Name", text: $newItemName)
                                            .padding()
                                        TextField("Item Price", text: $newItemPrice)
                                            .padding()
                                        Button(action: {
                                            addNewItem(index)
                                        }) {
                                            Text("Add Item")
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(6)
                                    }
                                } .padding(15)
                            }.background(Color.black)
                            // Add item input fields and button
                        }
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
    func getRect()->CGRect{
        return NSScreen.main!.visibleFrame
    }
}

#Preview {
    Home()
}
