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
    var isCustom: Bool
    var ingredients: [IngredientDomainModel]
    var extraInfo: [String]
    var resources: [ResourceDomainModel]
    var links: [URL?]
    
    init(id: String = UUID().uuidString,
         title: String,
         type: String? = nil,
         description: String,
         isFavorite: Bool = false,
         people: Int,
         preparation: String,
         dateUpdated: Date,
         time: Double,
         isCustom: Bool,
         ingredients: [IngredientDomainModel],
         extraInfo: [String],
         resources: [ResourceDomainModel],
         links: [URL?] = []) {
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
        self.isCustom = isCustom
        self.links = links
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

struct ResourceDomainModel {
    let id: String
    let image: Data
    let url: URL?
    
    init(id: String = UUID().uuidString,
         image: Data = Data(),
         url: URL? = nil) {
        self.id = id
        self.image = image
        self.url = url
    }
}
