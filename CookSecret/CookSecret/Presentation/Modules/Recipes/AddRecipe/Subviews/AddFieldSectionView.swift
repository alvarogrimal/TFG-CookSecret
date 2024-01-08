//
//  AddRecipeSectionView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import SwiftUI

struct AddRecipeSectionAction {
    var action: () -> Void
    var show: Bool
    
    init(action: @escaping () -> Void = {}, show: Bool = false) {
        self.action = action
        self.show = show
    }
}

struct AddFieldSectionView<Content: View>: View {
    
    let title: String
    var content: () -> Content
    var action: AddRecipeSectionAction

    var body: some View {
        VStack {
            HStack {
                Text(title.localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.pelorous)
                Spacer()
                if action.show {
                    Button(action: action.action) {
                        Image.plus
                            .tint(.indigo)
                    }
                }
            }
            content()
        }
    }
}
