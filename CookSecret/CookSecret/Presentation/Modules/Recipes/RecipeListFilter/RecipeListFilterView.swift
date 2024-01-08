//
//  RecipeListFilterView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 29/11/23.
//

import SwiftUI

struct RecipeListFilterView: View {
    
    // MARK: - Constants
    
    private enum ViewConstants {
        static let sectionSpacing: CGFloat = 17
        static let sectionVerticalPadding: CGFloat = 8
        static let ingredientRowHeight: CGFloat = 50
        static let ingredientDeleteSize: CGFloat = 16
        static let ingredientCapsulePadding: CGFloat = 8
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: RecipeListFilterViewModel
    @Environment(\.dismiss) var dismiss
    @State var width: CGFloat = 0
    @State var width1: CGFloat = UIScreen.main.bounds.width - 60
    @State var totalWidth = UIScreen.main.bounds.width - 60
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: ViewConstants.sectionSpacing) {
                    HStack {
                        Text("filter_favourites".localized)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.pelorous)
                        Spacer()
                        
                        Toggle("", isOn: $viewModel.checkFavourites)
                            .tint(.persianBlue)
                    }
                    Divider()
                    
                    // Type
                    AddFieldSectionView(title: "filter_type".localized, content: {
                        Menu {
                            Picker("", selection: $viewModel.typeValue) {
                                ForEach(RecipeType.allCases.map({ $0.getValue() }), id: \.self) {
                                    Text($0)
                                }
                            }
                        } label: {
                            VStack(alignment: .leading,
                                   spacing: ViewConstants.sectionVerticalPadding) {
                                Text(viewModel.type?.getValue() ?? "")
                                Divider()
                            }
                        }
                        .foregroundColor(.gray)
                    }, action: .init())
                    
                    // Time
                    AddFieldSectionView(title: "filter_time".localized, content: {
                        VStack {
                            Text("\(Utils.getShortTime(from: viewModel.initRangeTime)) - \(Utils.getShortTime(from: viewModel.finishRangeTime))")
                                .foregroundColor(.doveGray)
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.black.opacity(0.20))
                                    .frame(height: 6)
                                Rectangle()
                                    .fill(Color.aamir)
                                    .frame(width: width1 - width, height: 6)
                                    .offset(x: width + 18)
                                
                                HStack(spacing: .zero) {
                                    Circle()
                                        .fill(Color.aamir)
                                        .frame(width: 18, height: 18)
                                        .offset(x: self.width)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    if value.location.x >= 0 &&
                                                        value.location.x <= width1 {
                                                        width = value.location.x
                                                        viewModel.setTimeValues(initPercentage: Float(width/totalWidth),
                                                                                finishPercentaje: Float(width1/totalWidth))
                                                    }
                                                }
                                        )
                                    Circle()
                                        .fill(Color.aamir)
                                        .frame(width: 18, height: 18)
                                        .offset(x: self.width1)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    if value.location.x <= totalWidth &&
                                                        value.location.x >= width {
                                                        width1 = value.location.x
                                                        viewModel.setTimeValues(initPercentage: Float(width/totalWidth),
                                                                                finishPercentaje: Float(width1/totalWidth))
                                                    }
                                                }
                                        )
                                }
                            }
                        }
                    }, action: .init())
                    
                    // Ingredients
                    AddFieldSectionView(title: "filter_ingredients".localized, content: {
                        VStack(spacing: ViewConstants.sectionVerticalPadding) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.ingredients,
                                            id: \.self) { element in
                                        HStack {
                                            Text(element)
                                                .foregroundColor(.whiteSalt)
                                            Image.cross
                                                .resizable()
                                                .frame(width: ViewConstants.ingredientDeleteSize,
                                                       height: ViewConstants.ingredientDeleteSize)
                                                .onTapGesture {
                                                    viewModel.deleteIngredient(value: element)
                                                }
                                        }
                                        .padding(.horizontal,
                                                 ViewConstants.ingredientCapsulePadding)
                                        .background(
                                            Capsule()
                                                .fill(Color.persianBlue)
                                                .clipped()
                                        )
                                        .clipShape(Capsule())
                                    }
                                    Spacer()
                                }
                            }
                            
                            TextField("filter_ingredients_placeholder",
                                      text: $viewModel.ingredientValue)
                            .onSubmit {
                                viewModel.submitIngredient()
                            }
                            Divider()
                            List {
                                ForEach($viewModel.ingredientSuggestions,
                                        id: \.self) { ingredient in
                                    Text(ingredient.wrappedValue)
                                        .onTapGesture {
                                            viewModel.ingredientValue = ingredient.wrappedValue
                                        }
                                        .lineLimit(1)
                                }
                            }
                            .listStyle(.plain)
                            .frame(height: CGFloat(viewModel.ingredientSuggestions.count) *
                                   ViewConstants.ingredientRowHeight)
                        }
                    }, action: .init())
                }
                .padding()
            }
            .onAppear {
                totalWidth = proxy.size.width - 60
                width = (viewModel.initRangeTime / viewModel.maxTime) * totalWidth
                width1 = (viewModel.finishRangeTime / viewModel.maxTime) * totalWidth
            }
            .navigationTitle("filter_title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("general_cancel".localized) {
                        dismiss()
                    }
                    .tint(.persianBlue)
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("general_reset".localized) {
                        viewModel.reset()
                        width = 0
                        width1 = totalWidth
                    }
                    .tint(.persianBlue)
                    
                    Button("general_apply".localized) {
                        viewModel.apply()
                        dismiss()
                    }
                    .tint(.persianBlue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    
                }
            })
        }

    }
}

#Preview {
    RecipeListFilterView(viewModel: .sample)
}
