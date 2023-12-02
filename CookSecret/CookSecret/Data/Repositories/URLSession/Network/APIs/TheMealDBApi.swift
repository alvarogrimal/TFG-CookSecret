//
//  TheMealDBApi.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 2/12/23.
//

import Foundation

enum TheMealDBApi {
    case getCategories
    case getMealsBy(urlParameters: [URLParam])
    case getMeal(urlParameters: [URLParam])
    
    static var commonPath: String = "/api/json/v1/1"
}

extension TheMealDBApi: ApiBuilder {
    var baseProtocol: String { "https" }
    
    var host: String { "www.themealdb.com" }
    
    var path: String {
        switch self {
        case .getCategories:
            TheMealDBApi.commonPath + "/categories.php"
        case .getMealsBy:
            TheMealDBApi.commonPath + "/filter.php"
        case .getMeal:
            TheMealDBApi.commonPath + "/lookup.php"
        }
    }
    
    var httpMethod: HttpMethod { .get }
    
    var parameters: Encodable? { nil }
    
    var urlParameters: [URLParam] {
        switch self {
        case .getCategories:
            []
        case .getMealsBy(let urlParameters),
                .getMeal(let urlParameters):
            urlParameters
        }
    }
}
