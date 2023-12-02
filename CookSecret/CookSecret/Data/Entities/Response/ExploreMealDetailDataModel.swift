//
//  ExploreMealDetailDataModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 3/12/23.
//

import Foundation

struct ExploreMealDetailDataModel: Decodable {
    let meals: [ExploreMealDetailItemDataModel]?
}

struct ExploreMealDetailItemDataModel: Decodable {
    let idMeal: String?
    let strMeal: String?
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?
    let strTags: String?
    let strYoutube: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    let strSource: String?
}

extension ExploreMealDetailDataModel {
    func parseToDomain() -> RecipeDomainModel? {
        if let recipe = meals?.first {
            return RecipeDomainModel(
                id: recipe.idMeal ?? UUID().uuidString,
                title: recipe.strMeal ?? "",
                type: nil,
                description: "",
                people: .zero,
                preparation: recipe.strInstructions ?? "",
                dateUpdated: .now,
                time: .zero,
                isCustom: false,
                ingredients: getIngredients(from: recipe),
                extraInfo: [recipe.strArea, recipe.strCategory, recipe.strTags].compactMap({ $0 }),
                resources: [.init(url: .init(string: recipe.strMealThumb ?? ""))],
                links: [.init(string: recipe.strYoutube ?? ""),
                        .init(string: recipe.strSource ?? "")])
        }
        return nil
    }
    
    func getIngredients(from recipe: ExploreMealDetailItemDataModel) -> [IngredientDomainModel] {
        var ingredients: [IngredientDomainModel] = []
        
        appendIngredient(list: &ingredients, name: recipe.strIngredient1, measure: recipe.strMeasure1)
        appendIngredient(list: &ingredients, name: recipe.strIngredient2, measure: recipe.strMeasure2)
        appendIngredient(list: &ingredients, name: recipe.strIngredient3, measure: recipe.strMeasure3)
        appendIngredient(list: &ingredients, name: recipe.strIngredient4, measure: recipe.strMeasure4)
        appendIngredient(list: &ingredients, name: recipe.strIngredient5, measure: recipe.strMeasure5)
        appendIngredient(list: &ingredients, name: recipe.strIngredient6, measure: recipe.strMeasure6)
        appendIngredient(list: &ingredients, name: recipe.strIngredient7, measure: recipe.strMeasure7)
        appendIngredient(list: &ingredients, name: recipe.strIngredient8, measure: recipe.strMeasure8)
        appendIngredient(list: &ingredients, name: recipe.strIngredient9, measure: recipe.strMeasure9)
        appendIngredient(list: &ingredients, name: recipe.strIngredient10, measure: recipe.strMeasure10)
        appendIngredient(list: &ingredients, name: recipe.strIngredient11, measure: recipe.strMeasure11)
        appendIngredient(list: &ingredients, name: recipe.strIngredient12, measure: recipe.strMeasure12)
        appendIngredient(list: &ingredients, name: recipe.strIngredient13, measure: recipe.strMeasure13)
        appendIngredient(list: &ingredients, name: recipe.strIngredient14, measure: recipe.strMeasure14)
        appendIngredient(list: &ingredients, name: recipe.strIngredient15, measure: recipe.strMeasure15)
        appendIngredient(list: &ingredients, name: recipe.strIngredient16, measure: recipe.strMeasure16)
        appendIngredient(list: &ingredients, name: recipe.strIngredient17, measure: recipe.strMeasure17)
        appendIngredient(list: &ingredients, name: recipe.strIngredient18, measure: recipe.strMeasure18)
        appendIngredient(list: &ingredients, name: recipe.strIngredient19, measure: recipe.strMeasure19)
        appendIngredient(list: &ingredients, name: recipe.strIngredient20, measure: recipe.strMeasure20)
        
        return ingredients
    }
    
    func appendIngredient(list: inout [IngredientDomainModel], name: String?, measure: String?) {
        if let name,
           let measure,
           !name.isEmpty,
           !measure.isEmpty {
            list.append(.init(name: name, quantity: measure))
        }
    }
}
