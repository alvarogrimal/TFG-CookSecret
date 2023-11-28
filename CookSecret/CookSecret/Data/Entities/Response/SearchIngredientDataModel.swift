//
//  SearchIngredientDataModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

struct SearchIngredientDataModel: Decodable {
    let products: [SearchIngredientItemDataModel]?
}

struct SearchIngredientItemDataModel: Decodable {
    let genericNameES: String?
    let genericNameEN: String?
    
    enum CodingKeys: String, CodingKey {
        case genericNameES = "generic_name_es"
        case genericNameEN = "generic_name_en"
    }
}

extension SearchIngredientDataModel {
    func parseToDomain() -> [String] {
        (products?.compactMap({
            Locale.current.language.languageCode?.identifier == "es" ? $0.genericNameES : $0.genericNameEN
        }) ?? []).sorted(by: { $0.count > $1.count })
    }
}
