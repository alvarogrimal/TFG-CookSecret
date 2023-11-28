//
//  AddRecipeView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import SwiftUI

struct AddRecipeView: View {
    
    // MARK: - Constants
    
    private enum ViewConstants {
        static let verticalPadding: CGFloat = 24
        static let sectionVerticalPadding: CGFloat = 8
        static let timerHeight: CGFloat = 116
        static let peopleLimit: ClosedRange<Int> = 1...20
        static let preparationLineLimit: ClosedRange<Int> = 2...4
        static let ingredientRowHeight: CGFloat = 50
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: AddRecipeViewModel
    @Environment(\.dismiss) var dismiss
    @State var showResourceDialog: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: ViewConstants.verticalPadding) {
                // Title
                AddFieldSectionView(title: "add_recipe_title", content: {
                    VStack(spacing: ViewConstants.sectionVerticalPadding) {
                        TextField("add_recipe_add_title",
                                  text: $viewModel.title)
                        Divider()
                    }
                }, action: .init())
                
                // Description
                AddFieldSectionView(title: "add_recipe_description", content: {
                    VStack(spacing: ViewConstants.sectionVerticalPadding) {
                        TextField("add_recipe_add_descrition",
                                  text: $viewModel.description)
                        Divider()
                    }
                }, action: .init())
                
                // Time
                AddFieldSectionView(title: "add_recipe_time", content: {
                    VStack(spacing: ViewConstants.sectionVerticalPadding) {
                        TimerView(model: viewModel.timer)
                            .frame(height: ViewConstants.timerHeight)
                        Divider()
                    }
                }, action: .init())
                
                // People
                AddFieldSectionView(title: "add_recipe_people", content: {
                    Stepper(viewModel.getPeopleText(),
                            value: $viewModel.people,
                            in: ViewConstants.peopleLimit)
                }, action: .init())
                
                // Type
                AddFieldSectionView(title: "add_recipe_type", content: {
                    Menu {
                        Picker("", selection: $viewModel.typeValue) {
                            ForEach(RecipeType.allCases.map({ $0.getValue() }), id: \.self) {
                                Text($0)
                            }
                        }
                    } label: {
                        VStack(alignment: .leading,
                               spacing: ViewConstants.sectionVerticalPadding) {
                            Text(viewModel.type.getValue())
                            Divider()
                        }
                    }
                    .foregroundColor(.gray)
                }, action: .init())
                
                // Ingredients
                AddFieldSectionView(title: "add_recipe_ingredients", content: {
                    List {
                        ForEach(viewModel.ingredients, id: \.id) { ingredient in
                            HStack {
                                Text(ingredient.title)
                                Spacer()
                                Text(ingredient.quantity)
                            }
                        }
                        .onDelete(perform: viewModel.deleteIngredient)
                    }
                    .listStyle(.plain)
                    .frame(height: CGFloat(viewModel.ingredients.count) * ViewConstants.ingredientRowHeight)
                }, action: .init(action: {
                    viewModel.addIngredient()
                }, show: true))
                
                // Preparation
                AddFieldSectionView(title: "add_recipe_preparation", content: {
                    VStack(spacing: ViewConstants.sectionVerticalPadding) {
                        TextField("add_recipe_add_preparation",
                                  text: $viewModel.preparation,
                                  axis: .vertical)
                        .lineLimit(ViewConstants.preparationLineLimit)
                        .textFieldStyle(.roundedBorder)
                        
                        Divider()
                    }
                }, action: .init())
                
                // Resources
                AddFieldSectionView(title: "add_recipe_resources", content: {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.resources,
                                    id: \.id) { element in
                                AddRecipeResourceItemView(
                                    element: element,
                                    removeAction: viewModel.deleteResource(id: element.id))
                            }
                        }
                    }
                }, action: .init(action: {
                    showResourceDialog.toggle()
                }, show: true))
                .confirmationDialog("".localized,
                                    isPresented: $showResourceDialog) {
                    Button("add_recipe_gallery") {
                        viewModel.openGallery()
                    }
                    Button("add_recipe_camera") {
                        viewModel.openGallery()
                    }
                }
            }
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button("general_cancel") {
                    dismiss()
                }
                .tint(.black)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("general_save") {
                    Task {
                        await viewModel.save()
                        dismiss()
                    }
                }
                .disabled(!viewModel.checkSaveIsEnable())
                .tint(.black)
                
            }
        })
        .navigationBarTitle("add_recipe_nav_title")
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(true)

    }
}

#Preview {
    AddRecipeView(viewModel: .sample)
}
