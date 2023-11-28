//
//  OpenFoodFactsApi.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

enum OpenFoodFactsApi {
    case searchByProduct(urlParameters: [URLParam])
}

extension OpenFoodFactsApi: ApiBuilder {
    var baseProtocol: String { "https" }
    
    var host: String { "world.openfoodfacts.org" }
    
    var path: String { "/cgi/search.pl" }
    
    var httpMethod: HttpMethod { .get }
    
    var parameters: Encodable? { nil }
    
    var urlParameters: [URLParam] {
        switch self {
        case .searchByProduct(let urlParameters):
            urlParameters
        }
    }
}
