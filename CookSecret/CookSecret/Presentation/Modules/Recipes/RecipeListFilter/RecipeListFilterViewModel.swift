//
//  RecipeListFilterViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 29/11/23.
//

import Foundation

protocol RecipeListFilterDelegate: AnyObject {
    func applyFilter()
}

final class RecipeListFilterViewModel: BaseViewModel<RecipeCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var checkFavourites: Bool = false
    @Published var type: RecipeType?
    @Published var typeValue: String = "" {
        didSet {
            switch typeValue {
            case RecipeType.starter.getValue():
                type = RecipeType.starter
            case RecipeType.principal.getValue():
                type = RecipeType.principal
            case RecipeType.secondary.getValue():
                type = RecipeType.secondary
            case RecipeType.dessert.getValue():
                type = RecipeType.dessert
            default:
                type = nil
            }
        }
    }
    @Published var ingredientValue: String = ""
    @Published var ingredients: [String] = []
    @Published var ingredientSuggestions: [String] = []
    @Published var initRangeTime: Double = .zero
    @Published var finishRangeTime: Double = 24 * 3600
    
    private let searchIngredientUseCase: SearchIngredientUseCase
    private weak var delegate: RecipeListFilterDelegate?
    let minTime: Double = .zero
    let maxTime: Double = 24 * 3600
    
    // MARK: - Lifecycle
    
    init(searchIngredientUseCase: SearchIngredientUseCase,
         delegate: RecipeListFilterDelegate?,
         coordinator: BaseCoordinatorProtocol) {
        self.searchIngredientUseCase = searchIngredientUseCase
        self.delegate = delegate
        super.init(coordinator: coordinator)
        configureSubscribers()
    }
    
    // MARK: - Internal functions
    
    func submitIngredient() {
        if !ingredients.contains(where: { $0.lowercased() == ingredientValue.lowercased() }) {
            ingredients.append(ingredientValue)
            ingredientValue = ""
        }
    }
    
    func deleteIngredient(value: String) {
        ingredients.removeAll(where: { $0 == value })
    }
    
    func setTimeValues(initPercentage: Float, finishPercentaje: Float) {
        initRangeTime = maxTime * Double(initPercentage)
        finishRangeTime = maxTime * Double(finishPercentaje)
    }
    
    func reset() {
        checkFavourites = false
        typeValue = ""
        ingredients = []
        ingredientValue = ""
        initRangeTime = minTime
        finishRangeTime = maxTime
        ingredientSuggestions = []
    }
    
    func apply() {
        delegate?.applyFilter()
    }
    
    func hasFilter() -> Bool {
        !(!checkFavourites &&
          typeValue == "" &&
          ingredients == [] &&
          ingredientValue == "" &&
          initRangeTime == minTime &&
          finishRangeTime == maxTime &&
          ingredientSuggestions == [])
    }
    
    // MARK: - Private functions
    
    private func configureSubscribers() {
        $ingredientValue
            .sink { [weak self] value in
                guard let self,
                      !value.isEmpty else { return }
                
                self.getSuggestions()
            }
            .store(in: &cancellableSet)
    }
    
    private func getSuggestions() {
        Task {
            do {
                let suggestions = try await searchIngredientUseCase.execute(ingredientValue)
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

extension RecipeListFilterViewModel {
    static let sample: RecipeListFilterViewModel = {
        .init(searchIngredientUseCase: DependencyInjector.searchIngredientUseCase(), 
              delegate: nil,
              coordinator: RecipeCoordinator.sample)
    }()
}
