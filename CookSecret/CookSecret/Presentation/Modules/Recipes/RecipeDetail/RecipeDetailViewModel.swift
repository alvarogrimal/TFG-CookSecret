//
//  RecipeDetailViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 28/11/23.
//

import SwiftUI

struct InfoRecipeDetailViewModel: Identifiable {
    
    enum InfoType {
        case time, people, recipeType, other
        
        func getImage() -> Image? {
            switch self {
            case .time:
                return Image.clock
            case .people:
                return Image.people
            case .recipeType:
                return Image.forkKnife
            case .other:
                return nil
            }
        }
    }
    let id: UUID
    let type: InfoType
    let value: String
}

final class RecipeDetailViewModel: BaseViewModel<RecipeCoordinatorProtocol> {
    
    // MARK: - Properties
    
    var resources: [Data] = []
    var title: String = ""
    var info: [InfoRecipeDetailViewModel] = []
    var desc: String = ""
    var ingredients: [RecipeIngredientViewModel] = []
    var preparation: String = ""
    @Published var isFavorite: Bool = false
    private var recipeDomainModel: RecipeDomainModel
    private let setRecipeFavoriteUseCase: SetRecipeFavouriteUseCase
    private let deleteRecipeUseCase: DeleteRecipeUseCase
    private let getRecipeUseCase: GetRecipeUseCase
    
    // MARK: - Lifecycle
    
    init(recipeDomainModel: RecipeDomainModel,
         setRecipeFavoriteUseCase: SetRecipeFavouriteUseCase,
         deleteRecipeUseCase: DeleteRecipeUseCase,
         getRecipeUseCase: GetRecipeUseCase,
         coordinator: BaseCoordinatorProtocol) {
        self.recipeDomainModel = recipeDomainModel
        self.setRecipeFavoriteUseCase = setRecipeFavoriteUseCase
        self.deleteRecipeUseCase = deleteRecipeUseCase
        self.getRecipeUseCase = getRecipeUseCase
        
        super.init(coordinator: coordinator)
    }
    
    override func onLoad() {
        super.onLoad()
        parseToView()
    }
    
    // MARK: - Internal funtions
    
    func setFavorite() {
        Task {
            do {
                try await setRecipeFavoriteUseCase.execute(.init(id: recipeDomainModel.id,
                                                                 isFavourite: !isFavorite))
                NotificationCenter.default.post(name: .updateList, object: nil)
                print("✅ Success: Set favorite")
                Task { @MainActor in
                    isFavorite.toggle()
                }
            } catch {
                print("❌ Error: Set favorite")
            }
        }
    }
    
    func deleteRecipe(completion: @escaping () -> Void) {
        Task {
            do {
                try await deleteRecipeUseCase.execute(recipeDomainModel.id)
                print("✅ Success: Delete recipe")
                Task { @MainActor in
                    NotificationCenter.default.post(name: .updateList, object: nil)
                    completion()
                }
            } catch {
                print("❌ Error: Delete recipe")
            }
        }
        
    }
    
    func editRecipe() {
        getCoordinator()?.editRecipe(recipeDomainModel,
                                     delegate: self)
    }
    
    // MARK: - Private functions
    
    private func parseToView() {
        resources = recipeDomainModel.resources.compactMap({ $0.image })
        title = recipeDomainModel.title
        desc = recipeDomainModel.description
        ingredients = recipeDomainModel.ingredients.compactMap({
            .init(title: $0.name, quantity: $0.quantity)
        })
        preparation = recipeDomainModel.preparation
        isFavorite = recipeDomainModel.isFavorite
        
        if recipeDomainModel.extraInfo.isEmpty {
            let people = String(format: recipeDomainModel.people == 1 ?
                                "add_recipe_person_format".localized :
                                 "add_recipe_people_format".localized,
                                recipeDomainModel.people)
            info = [
                .init(id: UUID(),
                      type: .time,
                      value: Utils.getShortTime(from: recipeDomainModel.time)),
                .init(id: UUID(),
                      type: .people,
                      value: people),
                .init(id: UUID(),
                      type: .recipeType,
                      value: RecipeType(rawValue: recipeDomainModel.type ?? "")?.getValue() ?? "")
            ]
        } else {
            info = recipeDomainModel.extraInfo.compactMap({
                .init(id: UUID(), type: .other, value: $0.description)
            })
        }
    }
}

// MARK: - EditRecipeDelegate

extension RecipeDetailViewModel: EditRecipeDelegate {
    func editRecipeCompleted() async throws {
        recipeDomainModel = try await getRecipeUseCase.execute(recipeDomainModel.id) ?? recipeDomainModel
        parseToView()
    }
}

// MARK: - Mock

extension RecipeDetailViewModel {
    static let sample: RecipeDetailViewModel = {
        .init(recipeDomainModel: .init(title: "",
                                       description: "",
                                       people: .zero,
                                       preparation: "",
                                       dateUpdated: .now,
                                       time: .zero,
                                       isCustom: true,
                                       ingredients: [],
                                       extraInfo: [],
                                       resources: []),
              setRecipeFavoriteUseCase: DependencyInjector.setRecipeFavoriteUseCase(),
              deleteRecipeUseCase: DependencyInjector.deleteRecipeUseCase(), 
              getRecipeUseCase: DependencyInjector.getRecipeUseCase(),
              coordinator: RecipeCoordinator.sample)
    }()
}
