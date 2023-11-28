//
//  URLParam.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

struct URLParam {

    enum ParamKeys: String {
        case searchTerms = "search_terms"
        case searchSimple = "search_simple"
        case json
    }

    let key: ParamKeys
    let value: String
}
