//
//  ApiBuilder.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

protocol ApiBuilder {
    var baseProtocol: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var parameters: Encodable? { get }
    var urlParameters: [URLParam] { get }
    var urlRequest: URLRequest? { get }
}

extension ApiBuilder {
    var urlRequest: URLRequest? {

        let urlParams = urlParameters

        var components = URLComponents()
        components.scheme = baseProtocol
        components.host = host
        components.path = path

        let extra = urlParams.compactMap({ URLQueryItem(name: $0.key.rawValue, value: $0.value) })
        if !extra.isEmpty {
            components.queryItems = extra
        }

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)

        request.httpMethod = httpMethod.rawValue
        request.setValue("\(Locale.current.language.languageCode?.identifier ?? "")-\(Locale.current.region?.identifier ?? "")",
                         forHTTPHeaderField: "accept-language")
        
        if httpMethod != .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let parameters = parameters {
                let jsonData = try? JSONEncoder().encode(parameters)
                request.httpBody = jsonData
            }
        }

        return request
    }
}
