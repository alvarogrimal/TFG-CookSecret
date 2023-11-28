//
//  RecipeDomainModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import Foundation

struct RecipeDomainModel {
    let id: String
    var title: String
    var type: String?
    var description: String
    var isFavorite: Bool
    var people: Int
    var preparation: String
    var dateUpdated: Date
    var time: Double
    var ingredients: [IngredientDomainModel]
    var extraInfo: [ExtraInfoDomainModel]
    var resources: [ResourceDomainModel]
    
    init(id: String = UUID().uuidString,
         title: String,
         type: String? = nil,
         description: String,
         isFavorite: Bool = false,
         people: Int,
         preparation: String,
         dateUpdated: Date,
         time: Double,
         ingredients: [IngredientDomainModel],
         extraInfo: [ExtraInfoDomainModel],
         resources: [ResourceDomainModel]) {
        self.id = id
        self.title = title
        self.type = type
        self.description = description
        self.isFavorite = isFavorite
        self.people = people
        self.preparation = preparation
        self.dateUpdated = dateUpdated
        self.time = time
        self.ingredients = ingredients
        self.extraInfo = extraInfo
        self.resources = resources
    }
}

struct IngredientDomainModel {
    let id: String
    var name: String
    var quantity: String
    
    init(id: String = UUID().uuidString,
         name: String,
         quantity: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
    }
}

struct ExtraInfoDomainModel {
    var title: String
    var description: String
}

struct ResourceDomainModel {
    let id: String
    let image: Data
    
    init(id: String = UUID().uuidString,
         image: Data) {
        self.id = id
        self.image = image
    }
}
