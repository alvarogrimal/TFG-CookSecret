//
//  BaseUseCase.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/11/23.
//

import Foundation
import Combine

open class BaseUseCase<Input, Output> {
    public func execute(_ input: Input? = nil) async throws -> Output? {
        guard let handle = try await handle(input: input) else {
            return nil
        }
        return handle
    }

    open func handle(input: Input? = nil) async throws -> Output? { nil }
}
