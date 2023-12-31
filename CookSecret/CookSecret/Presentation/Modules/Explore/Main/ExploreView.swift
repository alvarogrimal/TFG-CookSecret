//
//  ExploreView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 1/12/23.
//

import SwiftUI

struct ExploreView: View {
    
    // MARK: - Constants
    
    private enum ViewConstants {
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
    
    @ObservedObject var viewModel: ExploreViewModel
    
    var body: some View {
        ScrollView {
            Section {
                // Grid view
                LazyVGrid(columns: [.init(.adaptive(minimum: ViewConstants.itemWidth))],
                          spacing: ViewConstants.columnSpacing) {
                    ForEach(viewModel.recipeList, id: \.id) { item in
                        VStack(alignment: .center,
                               spacing: .zero) {
                            AsyncImage(url: item.thumbnailURL) { image in
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
                                    .fill(.alto)
                                    .frame(height: ViewConstants.itemHeight)
                            }
                            
                            VStack {
                                Spacer(minLength: .zero)
                                Text(item.title)
                                    .font(.title3)
                                    .fontWeight(.thin)
                                    .lineLimit(ViewConstants.itemTitleLineLimit)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, ViewConstants.itemTitleVerticalPadding)
                                    .padding(.horizontal, ViewConstants.itemTitleHorizonalPadding)
                                Spacer(minLength: .zero)
                            }
                        }
                               .background(.whiteSalt)
                               .cornerRadius(ViewConstants.itemCornerRadius)
                               .shadow(color: .black.opacity(ViewConstants.shadowOpacity),
                                       radius: ViewConstants.shadowRadius,
                                       x: ViewConstants.shadowX,
                                       y: ViewConstants.shadowY)
                               .onTapGesture {
                                   viewModel.openRecipe(id: item.id)
                               }
                    }
                }.padding()
            } header: {
                if viewModel.showCategories() {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.categoriesList,
                                    id: \.id) { item in
                                Button {
                                    viewModel.categorySelected(id: item.id)
                                } label: {
                                    Text(item.value)
                                        .fontWeight(item.selected ? .bold : .regular)
                                        .foregroundColor(item.selected ? .customWhite : .customBlack)
                                        .padding(.horizontal)
                                        .frame(height: 40)
                                        .background {
                                            Capsule()
                                                .fill(item.selected ? .persianBlue : .clear)
                                                .stroke(Color.customBlack,
                                                        lineWidth: 1)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }

        }
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search, {
            viewModel.searchByText()
        })
        .refreshable(action: { viewModel.refresh() })
        .navigationTitle("explore_title".localized)
        .navigationBarTitleDisplayMode(.large)
        .isBaseView(viewModel)
    }
}

#Preview {
    ExploreView(viewModel: .sample)
}
