//
//  AddRecipeResourceItemView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 23/11/23.
//

import SwiftUI

struct AddRecipeResourceItemView: View {
    
    // MARK: - Constants
    
    let element: RecipeResourceViewModel
    let removeAction: ()?
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Image(uiImage: .init(data: element.data)!)
                .resizable()
                .scaledToFill()
                .frame(width: ViewConstants.imageSize,
                       height: ViewConstants.imageSize)
                .clipped()
                .cornerRadius(ViewConstants.imageCornerRadius)
            
            VStack {
                HStack(alignment: .top, content: {
                    Spacer()
                    Button {
                        removeAction
                    } label: {
                        Image.cross
                            .frame(width: ViewConstants.deleteSize,
                                   height: ViewConstants.deleteSize)
                    }
                })
                Spacer()
            }
            .padding(ViewConstants.padding)
        }
    }
    
    // MARK: - Constants
    
    private enum ViewConstants {
        static let imageSize: CGFloat = 122
        static let imageCornerRadius: CGFloat = 8
        static let deleteSize: CGFloat = 16
        static let padding: CGFloat = 6
    }
}

#Preview {
    AddRecipeResourceItemView(element: .init(data: .init()),
                              removeAction: nil)
}
