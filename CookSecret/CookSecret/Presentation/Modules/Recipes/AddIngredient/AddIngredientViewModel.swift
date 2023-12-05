//
//  AddIngredientViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 27/11/23.
//

import Foundation

protocol AddIngredientDelegate: AnyObject {
    func addIngredient(_ ingredient: RecipeIngredientViewModel)
}

final class AddIngredientViewModel: BaseViewModel<BaseCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var ingredientSuggestions: [String] = []
    @Published var name: String = ""
    @Published var quantity: String = ""
    
    private weak var delegate: AddIngredientDelegate?
    private let searchIngredientUseCase: SearchIngredientUseCase
    
    // MARK: - Lifecycle
    
    init(coordinator: BaseCoordinatorProtocol,
         searchIngredientUseCase: SearchIngredientUseCase,
         delegate: AddIngredientDelegate?) {
        self.delegate = delegate
        self.searchIngredientUseCase = searchIngredientUseCase
        super.init(coordinator: coordinator)
        configureSubscribers()
    }
    
    // MARK: - Internal funtions
    
    func checkAddIsEnable() -> Bool {
        !name.isEmpty && !quantity.isEmpty
    }
    
    func addTapped() {
        delegate?.addIngredient(.init(title: name, quantity: quantity))
    }
    
    // MARK: - Private functions
    
    private func configureSubscribers() {
        $name
            .sink { [weak self] value in
                guard let self = self,
                      !value.isEmpty else { return }
                
                self.getSuggestions()
            }
            .store(in: &cancellableSet)
    }
    
    private func getSuggestions() {
        Task {
            do {
                let suggestions = try await searchIngredientUseCase.execute(name)
                print("✅ Success: Retrieved suggestions")
                Task { @MainActor in
                    ingredientSuggestions = Array(suggestions?.filter({ !$0.isEmpty }).prefix(3) ?? [])
                }
            } catch {
                print("❌ Error: Retrieved suggestions")
            }
        }
    }
}

// MARK: - Mock

extension AddIngredientViewModel {
    static let sample: AddIngredientViewModel = {
        .init(coordinator: RecipeCoordinator.sample, 
              searchIngredientUseCase: DependencyInjector.searchIngredientUseCase(),
              delegate: nil)
    }()
}
