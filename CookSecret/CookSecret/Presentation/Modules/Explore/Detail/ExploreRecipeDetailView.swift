//
//  ExploreRecipeDetailView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 3/12/23.
//

import SwiftUI

struct ExploreRecipeDetailView: View {
    
    // MARK: - Properties
    
    enum ViewConstants {
        static let sectionsSpacing: CGFloat = 17
        static let ingredientRowHeight: CGFloat = 50
        static let infoImageHeight: CGFloat = 20
        static let linkVerticalPadding: CGFloat = 8
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ExploreRecipeDetailViewModel
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader(content: { geometry in
            ScrollView {
                VStack(spacing: ViewConstants.sectionsSpacing) {
                    if !viewModel.resources.isEmpty {
                        TabView {
                            ForEach(viewModel.resources,
                                    id: \.self) { value in
                                AsyncImage(url: value) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width)
                                } placeholder: {
                                    Rectangle()
                                        .fill(.alto)
                                        .frame(width: geometry.size.width)
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(height: geometry.size.height / 3)
                    }
                    
                    HStack {
                        ForEach(viewModel.info, id: \.self) { value in
                            VStack {
                                Spacer(minLength: .zero)
                                Text(value)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.doveGray)
                                    .fontWeight(.thin)
                                Spacer(minLength: .zero)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    if !viewModel.links.isEmpty {
                        AddFieldSectionView(title: "explore_recipe_detail_links", content: {
                            ForEach($viewModel.links, id: \.self) { link in
                                HStack {
                                    Link(destination: link.wrappedValue, label: {
                                        Text(link.wrappedValue.host ?? "")
                                            .foregroundColor(.persianBlue)
                                            .fontWeight(.thin)
                                    })
                                    Spacer()
                                }
                                .padding(.vertical, ViewConstants.linkVerticalPadding)
                                
                                Divider()
                            }
                        }, action: .init())
                        .padding(.horizontal)
                    }
                    
                    if !viewModel.ingredients.isEmpty {
                        AddFieldSectionView(title: "add_recipe_ingredients", content: {
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
                                Divider()
                            }
                        }, action: .init())
                        .padding(.horizontal)
                    }
                    
                    AddFieldSectionView(title: "add_recipe_preparation", content: {
                        HStack {
                            Text(viewModel.preparation)
                                .foregroundColor(.doveGray)
                                .fontWeight(.thin)
                            Spacer(minLength: .zero)
                        }
                    }, action: .init())
                    .padding([.horizontal, .bottom])
                }
            }
        })
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .isBaseView(viewModel)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !viewModel.isAdded {
                        Button {
                            viewModel.addToRecipe()
                        } label: {
                            Image.plus
                                .foregroundColor(.persianBlue)
                        }
                    } else {
                        Button {
                            viewModel.setFavorite()
                        } label: {
                            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                                .foregroundColor(.persianBlue)
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteRecipe()
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
    }
}

#Preview {
    ExploreRecipeDetailView(viewModel: .sample)
}
