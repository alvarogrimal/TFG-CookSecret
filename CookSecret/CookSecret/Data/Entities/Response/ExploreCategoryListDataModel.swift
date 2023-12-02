//
//  ExploreCategoryListDataModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 2/12/23.
//

import Foundation

struct ExploreCategoryListDataModel: Decodable {
    let categories: [ExploreCategoryDataModel]?
}

struct ExploreCategoryDataModel: Decodable {
    let idCategory: String?
    let strCategory: String?
    let strCategoryThumb: String?
    let strCategoryDescription: String?
}

extension ExploreCategoryListDataModel {
    func parseToDomain() -> [ExploreCategoryDomainModel] {
        categories?.compactMap { category in
                .init(id: category.idCategory ?? "",
                      value: category.strCategory ?? "")
        } ?? []
    }
}
