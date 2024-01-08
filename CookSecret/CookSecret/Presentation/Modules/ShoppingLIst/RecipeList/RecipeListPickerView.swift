//
//  RecipeListPickerView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import SwiftUI

struct RecipeListPickerView: View {
    
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
        static let selectCheckSize: CGFloat = 20
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: RecipeListPickerViewModel
    @Environment(\.dismiss) var dismiss
    
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
                                            .fill(.gray)
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
                                   .overlay(content: {
                                       if item.selected {
                                           HStack {
                                               Spacer()
                                               VStack {
                                                   Image(systemName: "checkmark.circle.fill")
                                                       .resizable()
                                                       .frame(width: ViewConstants.selectCheckSize,
                                                              height: ViewConstants.selectCheckSize)
                                                       .foregroundColor(.white)
                                                       .background(.black)
                                                       .cornerRadius(ViewConstants.selectCheckSize/2)
                                                   Spacer()
                                               }
                                           }
                                       }
                                   })
                                   .onTapGesture {
                                       viewModel.select(at: item.id)
                                   }
                        }
                    }.padding(.horizontal)
                }
            }
        }
        .toolbar {
            if !viewModel.isEmptyList {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("general_add") {
                        viewModel.addTapped()
                        dismiss()
                    }
                    .disabled(viewModel.selectedItems.isEmpty)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("general_cancel") {
                    dismiss()
                }
            }
        }
        .navigationTitle("recipes_picker_title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .isBaseView(viewModel)
    }
}

#Preview {
    RecipeListPickerView(viewModel: .sample)
}
