//
//  AddIngredientView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import SwiftUI

struct AddIngredientView: View {
    
    // MARK: - Constants
    
    private enum ViewConstants {
        static let ingredientRowHeight: CGFloat = 50
        static let sectionVerticalPadding: CGFloat = 8
        static let verticalPadding: CGFloat = 24
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: AddIngredientViewModel
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: ViewConstants.verticalPadding) {
                AddFieldSectionView(title: "add_ingredient_name", content: {
                    VStack(spacing: ViewConstants.sectionVerticalPadding) {
                        TextField("add_ingredient_name_placeholder",
                                  text: $viewModel.name)
                        Divider()
                        List {
                            ForEach($viewModel.ingredientSuggestions,
                                    id: \.self) { ingredient in
                                Text(ingredient.wrappedValue)
                                    .onTapGesture {
                                        viewModel.name = ingredient.wrappedValue
                                    }
                                    .lineLimit(1)
                            }
                        }
                        .listStyle(.plain)
                        .frame(height: CGFloat(viewModel.ingredientSuggestions.count) *
                               ViewConstants.ingredientRowHeight)
                    }
                }, action: .init())
                
                AddFieldSectionView(title: "add_ingredient_quantity", content: {
                    VStack(spacing: ViewConstants.sectionVerticalPadding) {
                        TextField("add_ingredient_quantity_placeholder",
                                  text: $viewModel.quantity)
                        Divider()
                    }
                }, action: .init())
            }
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("general_add") {
                    viewModel.addTapped()
                    dismiss()
                }
                .disabled(!viewModel.checkAddIsEnable())
                .tint(.black)
                
            }
        })
        .navigationBarTitle("add_ingredient_title")
        .navigationBarTitleDisplayMode(.inline)
        .isBaseView(viewModel)
    }
}

#Preview {
    AddIngredientView(viewModel: .sample)
}
