//
//  RecipeListViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import Foundation
import UIKit

struct RecipeListItemViewModel: Identifiable {
    let id: String
    let title: String
    let image: Data
    let thumbnailURL: URL?
    var selected: Bool
    
    init(id: String = UUID().uuidString,
         title: String,
         image: Data,
         thumbnailURL: URL? = nil,
         selected: Bool = false) {
        self.id = id
        self.title = title
        self.image = image
        self.thumbnailURL = thumbnailURL
        self.selected = selected
    }
}

final class RecipeListViewModel: BaseViewModel<RecipeCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var recipeList: [RecipeListItemViewModel] = []
    @Published var searchText: String = ""
    @Published var isEmptyList: Bool = false
    
    private let getRecipesUseCase: GetRecipesUseCase
    private var domainList: [RecipeDomainModel] = [] {
        didSet {
            Task { @MainActor in
                isEmptyList = domainList.isEmpty
            }
        }
    }
    private var filter: RecipeListFilterViewModel?
    
    // MARK: - Lifecycle
    
    init(getRecipesUseCase: GetRecipesUseCase,
         coordinator: RecipeCoordinatorProtocol) {
        self.getRecipesUseCase = getRecipesUseCase
        super.init(coordinator: coordinator)
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(updateList),
                                               name: .updateList,
                                               object: nil)
    }
    
    override func onLoad() {
        super.onLoad()
        if let coordinator = getCoordinator() {
            filter = DependencyInjector.getRecipeListFilterViewModel(delegate: self,
                                                                     coordinator: coordinator)
        }
        configurePublishers()
        getRecipes()
    }
    
    // MARK: - Internal functions
    
    func addRecipeTapped() {
        getCoordinator()?.addRecipe()
    }
    
    func openRecipe(id: String) {
        if let recipe = domainList.first(where: { $0.id == id }) {
            getCoordinator()?.openRecipe(recipe)
        }
    }
    
    func refresh() {
        getRecipes()
    }
    
    func openFilters() {
        if let filter {
            getCoordinator()?.openFilters(filter: filter)
        }
    }
    
    // MARK: - Private functions
    
    private func configurePublishers() {
        $searchText
            .sink { [weak self] value in
                guard let self = self else { return }
                self.search(by: value)
            }
            .store(in: &cancellableSet)
    }
    
    private func getRecipes() {
        Task {
            do {
                domainList = try await getRecipesUseCase.execute() ?? []
                print("✅ Success: Retrived recipes")
                Task { @MainActor in
                    applyFilter()
                }
            } catch {
                print("❌ Error: Retrived recipes")
            }
        }
    }
    
    private func search(by value: String) {
        guard !value.isEmpty else {
            parseToViewList(domain: domainList)
            return
        }
        
        let domainFiltered = domainList.filter { recipe in
            recipe.title.lowercased().contains(value.lowercased())
        }
        parseToViewList(domain: domainFiltered)
    }
    
    private func parseToViewList(domain: [RecipeDomainModel]) {
        recipeList = domain
            .compactMap({ .init(id: $0.id,
                                title: $0.title,
                                image: $0.resources.first?.image ?? .init(),
                                thumbnailURL: $0.resources.first?.url) })
    }
    
    @objc private func updateList() {
        getRecipes()
    }
}

// MARK: - RecipeListFilterDelegate

extension RecipeListViewModel: RecipeListFilterDelegate {
    func applyFilter() {
        if let filter,
           filter.hasFilter() {
            let domainFiltered = domainList
                .filter { recipe in
                    if filter.checkFavourites {
                        return recipe.isFavorite
                    }
                    return true
                }
                .filter { recipe in
                    if let type = filter.type {
                        return recipe.type == type.rawValue
                    }
                    return true
                }
                .filter { recipe in
                    (filter.initRangeTime...filter.finishRangeTime).contains(recipe.time)
                }
                .filter { recipe in
                    if filter.ingredients.isEmpty { return true }
                    var containAnyIngredient = false
                    recipe.ingredients.forEach { item in
                        if !containAnyIngredient {
                            containAnyIngredient = filter.ingredients.contains(where: { $0.lowercased() == item.name.lowercased() })
                        }
                    }
                    return containAnyIngredient
                }
            
            parseToViewList(domain: domainFiltered)
        } else {
            parseToViewList(domain: domainList)
        }
    }
}

// MARK: - Mock

extension RecipeListViewModel {
    static let sample: RecipeListViewModel = {
        .init(getRecipesUseCase: DependencyInjector.getRecipesUseCase(),
              coordinator: RecipeCoordinator.sample)
    }()
}
