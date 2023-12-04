//
//  ExploreMealSummaryListDataModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 2/12/23.
//

import Foundation

struct ExploreMealSummaryListDataModel: Decodable {
    let meals: [ExploreMealSummaryDataModel]?
}

struct ExploreMealSummaryDataModel: Decodable {
    let strMeal: String?
    let strMealThumb: String?
    let idMeal: String?
}

extension ExploreMealSummaryListDataModel {
    func parseToDomain() -> [ExploreMealSummaryDomainModel] {
        meals?.compactMap({ meal in
                .init(id: meal.idMeal ?? "",
                      name: meal.strMeal ?? "",
                      thumbnail: .init(string: meal.strMealThumb ?? ""))
        }) ?? []
    }
}
