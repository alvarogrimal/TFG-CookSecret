//
//  ShoppingListDomainModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

struct ShoppingListDomainModel {
    var list: [ShoppingListItemDomainModel]
}

struct ShoppingListItemDomainModel {
    let id: String
    var name: String
    var quantity: String
    var completed: Bool
    
    init(id: String = UUID().uuidString,
         name: String,
         quantity: String,
         completed: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.completed = completed
    }
    
    init(ingredient: IngredientDomainModel,
         completed: Bool = false) {
        id = ingredient.id
        name = ingredient.name
        quantity = ingredient.quantity
        self.completed = completed
    }
}
