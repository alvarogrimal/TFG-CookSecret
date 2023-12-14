//
//  CalendarView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import SwiftUI

struct CalendarView: View {
    
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
        static let deleteRecipeButtonSize: CGFloat = 20
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: CalendarViewModel
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                CalendarViewRepresentable(calendar: $viewModel.calendar,
                                          selectedDate: $viewModel.selectedDate, 
                                          recipesPerDate: $viewModel.recipesPerDate)
                .frame(height: proxy.size.height/2)
                
                Divider()
                
                AddFieldSectionView(title: "recipes_picker_title", content: {
                    ScrollView {
                            // Grid view
                        LazyVGrid(columns: [.init(.adaptive(minimum: ViewConstants.itemWidth))],
                                  spacing: ViewConstants.columnSpacing) {
                            ForEach(viewModel.getItems(), id: \.id) { item in
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
                                       .overlay {
                                           VStack {
                                               HStack {
                                                   Spacer()
                                                   Button {
                                                       viewModel.delete(recipeId: item.id)
                                                   } label: {
                                                       Image.cross
                                                           .resizable()
                                                           .scaledToFit()
                                                           .frame(width: ViewConstants.deleteRecipeButtonSize,
                                                                  height: ViewConstants.deleteRecipeButtonSize)
                                                   }

                                               }
                                               Spacer()
                                           }
                                       }
                            }
                        }
                    }
                }, action: .init(action: {
                    viewModel.openRecipesPicker()
                }, show: true))
                .padding(.horizontal)
            }
        }
        .onAppear(perform: {
            viewModel.refresh()
        })
        .navigationTitle("calendar_title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("calendar_today_button") {
                    viewModel.todayTapped()
                }.tint(.persianBlue)
            }
        }
    }
}

#Preview {
    CalendarView(viewModel: .sample)
}
