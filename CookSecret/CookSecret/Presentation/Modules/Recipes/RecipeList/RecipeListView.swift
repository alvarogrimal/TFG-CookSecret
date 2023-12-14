//
//  RecipeListView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import SwiftUI

struct RecipeListView: View {
    
    // MARK: - Properties
    
    private enum ViewConstants {
        static let emptyViewPadding: CGFloat = 16
        static let emptyViewImageSize: CGFloat = 100
        static let itemWidth: CGFloat = 150
        static let itemHeight: CGFloat = 150
        static let columnSpacing: CGFloat = 16
        static let itemTitleLineLimit: Int = 2
        static let itemTitleHorizonalPadding: CGFloat = 8
        static let itemTitleVerticalPadding: CGFloat = 4
        static let itemCornerRadius: CGFloat = 8
        static let shadowOpacity: CGFloat = 0.25
        static let shadowRadius: CGFloat = 2
        static let shadowX: CGFloat = 0
        static let shadowY: CGFloat = 4
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: RecipeListViewModel
    
    // MARK: - Init
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if viewModel.isEmptyList {
                    // Emtpy view
                VStack(spacing: ViewConstants.emptyViewPadding) {
                    Spacer()
                    
                    Image.recipe
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.doveGray)
                        .frame(width: ViewConstants.emptyViewImageSize)
                    
                    Text("recipes_empty".localized)
                        .font(.body)
                        .fontWeight(.light)
                        .foregroundColor(.doveGray)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                        // Grid view
                    LazyVGrid(columns: [.init(.adaptive(minimum: ViewConstants.itemWidth))],
                              spacing: ViewConstants.columnSpacing) {
                        ForEach(viewModel.recipeList, id: \.id) { item in
                            VStack(alignment: .center,
                                   spacing: .zero) {
                                
                                if let thumbnail = item.thumbnailURL {
                                    AsyncImage(url: thumbnail) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: ViewConstants.itemHeight)
                                            .frame(minWidth: .zero,
                                                   maxWidth: .infinity)
                                            .clipped()
                                            .clipShape(Rectangle())
                                    } placeholder: {
                                        Rectangle()
                                            .frame(height: ViewConstants.itemHeight)
                                            .frame(minWidth: .zero,
                                                   maxWidth: .infinity)
                                    }

                                } else {
                                    Image(uiImage: .init(data: item.image) ?? UIImage())
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: ViewConstants.itemHeight)
                                        .frame(minWidth: .zero,
                                               maxWidth: .infinity)
                                        .clipped()
                                        .clipShape(Rectangle())
                                }
                                
                                Text(item.title)
                                    .font(.title3)
                                    .fontWeight(.thin)
                                    .lineLimit(ViewConstants.itemTitleLineLimit)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, ViewConstants.itemTitleVerticalPadding)
                                    .padding(.horizontal, ViewConstants.itemTitleHorizonalPadding)
                            }
                                   .background(.white)
                                   .cornerRadius(ViewConstants.itemCornerRadius)
                                   .shadow(color: .black.opacity(ViewConstants.shadowOpacity),
                                           radius: ViewConstants.shadowRadius,
                                           x: ViewConstants.shadowX,
                                           y: ViewConstants.shadowY)
                                   .onTapGesture {
                                       viewModel.openRecipe(id: item.id)
                                   }
                        }
                    }.padding(.horizontal)
                }
                .searchable(text: $viewModel.searchText)
                .refreshable(action: { viewModel.refresh() })
            }
        }
        .toolbar {
            if !viewModel.isEmptyList {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.openFilters() }, label: {
                        Image.filter
                            .tint(.csIndigo)
                    })
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.addRecipeTapped()
                }, label: {
                    Image.plus
                        .tint(.csIndigo)
                })
            }
        }
        .navigationTitle("recipes_title")
        .navigationBarTitleDisplayMode(.large)
        .isBaseView(viewModel)
    }
}

// MARK: - Preview

#Preview {
    RecipeListView(viewModel: .sample)
}
