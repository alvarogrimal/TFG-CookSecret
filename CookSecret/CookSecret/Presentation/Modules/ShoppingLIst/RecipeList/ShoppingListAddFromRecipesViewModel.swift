//
//  ShoppingListAddFromRecipesViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

protocol AddFromRecipesDelegate: AnyObject {
    func addIngredients(ingredients: [IngredientDomainModel])
}

final class ShoppingListAddFromRecipesViewModel: BaseViewModel<ShoppingListCoodinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var recipeList: [RecipeListItemViewModel] = []
    @Published var isEmptyList: Bool = false
    @Published var selectedItems: [String] = []
    
    private let getRecipesUseCase: GetRecipesUseCase
    private var domainList: [RecipeDomainModel] = [] {
        didSet {
            Task { @MainActor in
                isEmptyList = domainList.isEmpty
            }
        }
    }
    private weak var delegate: AddFromRecipesDelegate?
    
    // MARK: - Lifecycle
    
    init(delegate: AddFromRecipesDelegate?,
         getRecipesUseCase: GetRecipesUseCase,
         coordinator: ShoppingListCoodinatorProtocol) {
        self.delegate = delegate
        self.getRecipesUseCase = getRecipesUseCase
        super.init(coordinator: coordinator)
    }
    
    override func onLoad() {
        super.onLoad()
        getRecipes()
    }
    
    // MARK: - Internal functions
    
    func select(at id: String) {
        if let viewListIndex = recipeList.firstIndex(where: { $0.id == id }) {
            
            recipeList[viewListIndex].selected.toggle()
            
            if let index = selectedItems.firstIndex(where: { $0 == id }) {
                selectedItems.remove(at: index)
            } else {
                selectedItems.append(id)
            }
        }
    }
    
    func addIngredients() {
        let domainIngredientList = domainList.filter { item in
            selectedItems.contains(where: { $0 == item.id })
        }
            .flatMap({ $0.ingredients })
        
        delegate?.addIngredients(ingredients: domainIngredientList)
    }
    
    // MARK: - Private functions
    
    private func getRecipes() {
        Task {
            do {
                domainList = try await getRecipesUseCase.execute() ?? []
                print("✅ Success: Retrived recipes")
                Task { @MainActor in
                    parseToViewList(domain: domainList)
                }
            } catch {
                print("❌ Error: Retrived recipes")
            }
        }
    }
    
    private func parseToViewList(domain: [RecipeDomainModel]) {
        recipeList = domain
            .compactMap({ .init(id: $0.id,
                                title: $0.title,
                                image: $0.resources.first?.image ?? .init(),
                                thumbnailURL: $0.resources.first?.url) })
    }
    
}

// MARK: - Mock

extension ShoppingListAddFromRecipesViewModel {
    static let sample: ShoppingListAddFromRecipesViewModel = {
        .init(delegate: nil,
              getRecipesUseCase: DependencyInjector.getRecipesUseCase(),
              coordinator: ShoppingListCoodinator.sample)
    }()
}
