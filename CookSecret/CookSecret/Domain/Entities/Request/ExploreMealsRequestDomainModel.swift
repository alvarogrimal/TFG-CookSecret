//
//  ExploreMealsRequestDomainModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 2/12/23.
//

import Foundation

struct ExploreMealsRequestDomainModel {
    enum FilterType {
        case category, mainIngredient
    }
    
    let filterType: FilterType
    let value: String
}
