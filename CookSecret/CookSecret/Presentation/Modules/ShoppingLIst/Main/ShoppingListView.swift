//
//  ShoppingListView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import SwiftUI

struct ShoppingListView: View {
    
    // MARK: - Properties
    
    enum ViewConstants {
        static let checkSize: CGFloat = 20
        static let checkBorderWidth: CGFloat = 0.5
        static let itemCompletedOpacity: CGFloat = 0.4
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ShoppingListViewModel
    
    // MARK: - Body
    
    var body: some View {
        List {
            ForEach(viewModel.list, id: \.id) { item in
                HStack {
                    Rectangle()
                        .fill(item.completed ? .persianBlue : .clear)
                        .frame(width: ViewConstants.checkSize,
                               height: ViewConstants.checkSize)
                        .border(.persianBlue,
                                width: ViewConstants.checkBorderWidth)
                        .onTapGesture {
                            viewModel.setComplete(id: item.id)
                        }
                    
                    Text(item.name)
                        .font(.title3)
                        .foregroundColor(.persianBlue)
                        .opacity(item.completed ? ViewConstants.itemCompletedOpacity : 1)
                    Spacer()
                    Text(item.quantity)
                        .foregroundColor(.csIndigo)
                        .opacity(item.completed ? ViewConstants.itemCompletedOpacity : 1)
                }
            }
            .onDelete(perform: viewModel.deleteItem)
            .padding()
        }
        .listStyle(.plain)
        .navigationTitle("shopping_list_title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .isBaseView(viewModel)
        .refreshable {
            viewModel.getShoppingList()
        }
        .toolbar(content: {
            ToolbarItem {
                Menu {
                    Button("shopping_list_add_from_recipes".localized) {
                        viewModel.openAddFromRecipes()
                    }
                    Button("general_add") {
                        viewModel.openAddIngredient()
                    }
                } label: {
                    Image.plus
                        .tint(.csIndigo)
                }

            }
        })
    }
}

#Preview {
    ShoppingListView(viewModel: DependencyInjector.shoppingListViewModel(coordinator: ShoppingListCoodinator.sample))
}
