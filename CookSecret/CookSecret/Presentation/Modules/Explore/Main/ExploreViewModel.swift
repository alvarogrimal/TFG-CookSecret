//
//  ExploreViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 1/12/23.
//

import Foundation

struct ExploreCategoryViewModel: Identifiable {
    let id: String
    let value: String
    var selected: Bool
    
    init(id: String, value: String, selected: Bool = false) {
        self.id = id
        self.value = value
        self.selected = selected
    }
}

final class ExploreViewModel: BaseViewModel<ExploreCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var categoriesList: [ExploreCategoryViewModel] = []
    @Published var recipeList: [RecipeListItemViewModel] = []
    @Published var searchText: String = ""
    
    private let getExploreCategoriesUseCase: GetExploreCategoriesUseCase
    private let getExploreMealsUseCase: GetExploreMealsUseCase
    private var categoryDomainList: [ExploreCategoryDomainModel] = []
    private var recipeDomainList: [ExploreMealSummaryDomainModel] = []
    
    // MARK: - Lifecycle
    
    init(getExploreCategoriesUseCase: GetExploreCategoriesUseCase,
         getExploreMealsUseCase: GetExploreMealsUseCase,
         coordinator: BaseCoordinatorProtocol) {
        self.getExploreCategoriesUseCase = getExploreCategoriesUseCase
        self.getExploreMealsUseCase = getExploreMealsUseCase
        super.init(coordinator: coordinator)
    }
    
    override func onLoad() {
        super.onLoad()
        getCategories()
        
        $searchText
            .sink { [weak self] value in
                guard let self else { return }
                if value.isEmpty {
                    if let category = self.categoriesList.first(where: { $0.selected }) {
                        getRecipesBy(type: .category, value: category.value)
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    // MARK: - Internal funtions
    
    func searchByText() {
        self.getRecipesBy(type: .mainIngredient,
                          value: searchText)
    }
    
    func showCategories() -> Bool {
        searchText.isEmpty
    }
    
    func refresh() {
        
    }
    
    func openRecipe(id: String) {
        if let recipe = recipeDomainList.first(where: { $0.id == id }) {
            getCoordinator()?.openRecipe(recipe)
        }
    }
    
    func categorySelected(id: String) {
        for index in (0..<categoriesList.count) {
            categoriesList[index].selected = categoriesList[index].id == id
        }
        
        if let category = categoryDomainList.first(where: { $0.id == id }) {
            getRecipesBy(type: .category, value: category.value)
        }
    }

    // MARK: - Private functions

    private func getCategories() {
        Task {
            do {
                categoryDomainList = try await getExploreCategoriesUseCase.execute() ?? []
                if let category = categoryDomainList.first {
                    getRecipesBy(type: .category, value: category.value)
                }
                print("✅ Success: Get categories")
                
                Task { @MainActor in
                    categoriesList = categoryDomainList.compactMap({ category in
                            .init(id: category.id,
                                  value: category.value)
                    })
                    if !categoriesList.isEmpty {
                        categoriesList[.zero].selected = true
                    }
                    
                    recipeList = recipeDomainList.compactMap({ recipe in
                            .init(id: recipe.id, 
                                  title: recipe.name,
                                  image: Data(),
                                  thumbnailURL: recipe.thumbnail)
                    })
                }
            } catch {
                print("❌ Error: Get categories")
            }
        }
    }
    
    private func getRecipesBy(type: ExploreMealsRequestDomainModel.FilterType,
                              value: String) {
        Task {
            do {
                recipeDomainList = try await getExploreMealsUseCase.execute(.init(filterType: type,
                                                                                  value: value)) ?? []
                print("✅ Success: Get recipes by category")
                
                Task { @MainActor in
                    recipeList = recipeDomainList.compactMap({ recipe in
                            .init(id: recipe.id,
                                  title: recipe.name,
                                  image: Data(),
                                  thumbnailURL: recipe.thumbnail)
                    })
                }
            } catch {
                print("❌ Error: Get recipes by category")
            }
        }
    }
}

// MARK: - Mock

extension ExploreViewModel {
    static let sample: ExploreViewModel = {
        .init(getExploreCategoriesUseCase: DependencyInjector.getExploreCategoriesUseCase(),
              getExploreMealsUseCase: DependencyInjector.getExploreMealsUseCase(),
              coordinator: ExploreCoordinator.sample)
    }()
}
