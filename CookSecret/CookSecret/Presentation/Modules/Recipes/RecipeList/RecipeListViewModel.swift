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
    
    init(id: String = UUID().uuidString,
         title: String = "Spaghetti with tomato sauce",
         image: Data = UIImage(named: "mockRecipe")?.jpegData(compressionQuality: 1) ?? .init()) {
        self.id = id
        self.title = title
        self.image = image
    }
}

final class RecipeListViewModel: BaseViewModel<RecipeCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var recipeList: [RecipeListItemViewModel] = []
    @Published var searchText: String = ""
    
    private let getRecipesUseCase: GetRecipesUseCase
    private var domainList: [RecipeDomainModel] = []
    
    // MARK: - Lifecycle
    
    init(getRecipesUseCase: GetRecipesUseCase,
         coordinator: BaseCoordinatorProtocol) {
        self.getRecipesUseCase = getRecipesUseCase
        super.init(coordinator: coordinator)
    }
    
    override func onLoad() {
        super.onLoad()
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
                    recipeList = domainList
                        .compactMap({ .init(id: $0.id,
                                            title: $0.title,
                                            image: $0.resources.first?.image ?? .init()) })
                }
            } catch {
                print("❌ Error: Retrived recipes")
            }
        }
    }
    
    private func search(by value: String) {
        print(value)
    }
}

// MARK: - Mock

extension RecipeListViewModel {
    static let sample: RecipeListViewModel = {
        .init(getRecipesUseCase: DependencyInjector.getRecipesUseCase(),
              coordinator: RecipeCoordinator.sample)
    }()
}
