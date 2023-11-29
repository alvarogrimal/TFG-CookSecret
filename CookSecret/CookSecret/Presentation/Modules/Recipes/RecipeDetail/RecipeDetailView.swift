//
//  RecipeDetailView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import SwiftUI

struct RecipeDetailView: View {
    
    // MARK: - Constants
    
    private enum ViewConstants {
        static let sectionsSpacing: CGFloat = 17
        static let ingredientRowHeight: CGFloat = 50
        static let infoImageHeight: CGFloat = 20
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: RecipeDetailViewModel
    
    // MARK: - Body
        
    var body: some View {
        GeometryReader(content: { geometry in
            ScrollView {
                VStack(spacing: ViewConstants.sectionsSpacing) {
                    if !viewModel.resources.isEmpty {
                        TabView {
                            ForEach(viewModel.resources,
                                    id: \.self) { value in
                                Image(uiImage: .init(data: value) ?? .init())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width)
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(height: geometry.size.height / 3)
                    }
                    
                    HStack {
                        Spacer()
                        ForEach(viewModel.info) { value in
                            VStack {
                                if let image = value.type.getImage() {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.doveGray)
                                        .frame(height: ViewConstants.infoImageHeight)
                                }
                                
                                Text(value.value)
                                    .foregroundColor(.doveGray)
                                    .fontWeight(.thin)
                            }
                            Spacer()
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Text(viewModel.desc)
                        .foregroundColor(.doveGray)
                        .fontWeight(.thin)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    if !viewModel.ingredients.isEmpty {
                        AddFieldSectionView(title: "add_recipe_ingredients", content: {
                            List {
                                ForEach(viewModel.ingredients, id: \.id) { ingredient in
                                    HStack {
                                        Text(ingredient.title)
                                            .foregroundColor(.doveGray)
                                            .fontWeight(.thin)
                                        Spacer()
                                        Text(ingredient.quantity)
                                            .foregroundColor(.doveGray)
                                            .fontWeight(.thin)
                                    }
                                }
                            }
                            .listStyle(.plain)
                            .frame(height: CGFloat(viewModel.ingredients.count) * ViewConstants.ingredientRowHeight)
                        }, action: .init())
                        .padding(.horizontal)
                    }
                    
                    AddFieldSectionView(title: "add_recipe_preparation", content: {
                        Text(viewModel.preparation)
                            .foregroundColor(.doveGray)
                            .fontWeight(.thin)
                    }, action: .init())
                    .padding([.horizontal, .bottom])
                }
            }
        })
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    viewModel.isFavorite.toggle()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.persianBlue)
                }
                
                Menu {
                    Button {
                        
                    } label: {
                        Label("general_share".localized, systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        
                    } label: {
                        Label("general_edit".localized, systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("general_delete".localized, systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.persianBlue)
                }

            }
        }
    }
}

#Preview {
    RecipeDetailView(viewModel: .sample)
}
