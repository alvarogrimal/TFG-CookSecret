//
//  ShoppingListViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import Foundation

struct ShoppingListItemViewModel: Identifiable {
    let id: String
    let name: String
    let quantity: String
    var completed: Bool = false
}

final class ShoppingListViewModel: BaseViewModel<ShoppingListCoodinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var list: [ShoppingListItemViewModel] = []
    
    private let getShoppingListUseCase: GetShoppingListUseCase
    private let addShoppingListItemUseCase: AddShoppingListItemUseCase
    private let deleteShoppingListItemUseCase: DeleteShoppingListItemUseCase
    private let setCompleteShoppingListItemUseCase: SetCompleteShoppingListItemUseCase
    
    // MARK: - Lifecycle
    
    init(getShoppingListUseCase: GetShoppingListUseCase,
         addShoppingListItemUseCase: AddShoppingListItemUseCase,
         deleteShoppingListItemUseCase: DeleteShoppingListItemUseCase,
         setCompleteShoppingListItemUseCase: SetCompleteShoppingListItemUseCase,
         coordinator: ShoppingListCoodinatorProtocol) {
        self.getShoppingListUseCase = getShoppingListUseCase
        self.addShoppingListItemUseCase = addShoppingListItemUseCase
        self.deleteShoppingListItemUseCase = deleteShoppingListItemUseCase
        self.setCompleteShoppingListItemUseCase = setCompleteShoppingListItemUseCase
        super.init(coordinator: coordinator)
    }
    
    override func onLoad() {
        super.onLoad()
        getShoppingList()
    }
    
    // MARK: - Internal functions
    
    func openAddFromRecipes() {
        getCoordinator()?.addFromRecipes(delegate: self)
    }
    
    func openAddIngredient() {
        getCoordinator()?.addIngredient(delegate: self)
    }
    
    func setComplete(id: String) {
        if let item = list.first(where: { $0.id == id }) {
            setComplete(item: item)
        }
    }
    
    func getShoppingList() {
        Task {
            do {
                let domainList = try await getShoppingListUseCase.execute()
                Task { @MainActor in
                    list = (domainList?.list.compactMap({ item in
                            .init(id: item.id,
                                  name: item.name,
                                  quantity: item.quantity,
                                  completed: item.completed)
                    }) ?? []).sorted { !$0.completed && $1.completed }
                }
            } catch {
                
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        var index = 0
        offsets.forEach { value in
            index = value
        }
        let id = list[index].id
        
        Task {
            do {
                try await deleteShoppingListItemUseCase.execute(id)
                getShoppingList()
            } catch {
                
            }
        }
    }
    
    // MARK: - Private functions
    
    private func setComplete(item: ShoppingListItemViewModel) {
        Task {
            do {
                let request = SetCompleteShoppingListItemUseCaseModel(id: item.id,
                                                                      value: !item.completed)
                try await setCompleteShoppingListItemUseCase.execute(request)
                getShoppingList()
            } catch {
                
            }
        }
    }
    
    private func addListItem(_ domainModel: ShoppingListItemDomainModel) {
        Task {
            do {
                try await addShoppingListItemUseCase.execute(domainModel)
                getShoppingList()
            } catch {
                
            }
        }
    }
}

extension ShoppingListViewModel: AddIngredientDelegate,
                                 AddFromRecipesDelegate {
    func addIngredient(_ ingredient: RecipeIngredientViewModel) {
        addListItem(.init(id: ingredient.id,
                          name: ingredient.title,
                          quantity: ingredient.quantity))
    }
    
    func addIngredients(ingredients: [IngredientDomainModel]) {
        Task {
            do {
                for ingredient in ingredients {
                    try await self.addShoppingListItemUseCase.execute(.init(ingredient: ingredient))
                }
                getShoppingList()
            } catch {
                
            }
        }
    }
}
