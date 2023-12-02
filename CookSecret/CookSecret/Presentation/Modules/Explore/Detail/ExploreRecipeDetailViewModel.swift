//
//  ExploreRecipeDetailViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 3/12/23.
//

import Foundation

protocol ExploreRecipeDetailCoordinatorProtocol: BaseCoordinatorProtocol {
    func openRecipe(_ exploreRecipe: ExploreMealSummaryDomainModel)
}

final class ExploreRecipeDetailViewModel: BaseViewModel<ExploreRecipeDetailCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var title: String = ""
    @Published var resources: [URL?] = []
    @Published var info: [String] = []
    @Published var links: [URL] = []
    @Published var ingredients: [RecipeIngredientViewModel] = []
    @Published var preparation: String = ""
    @Published var isAdded: Bool = false
    @Published var isFavorite: Bool = false
    
    private var exploreRecipe: ExploreMealSummaryDomainModel?
    private var exploreRecipeDetail: RecipeDomainModel?
    private let getExploreMealDetailUseCase: GetExploreMealDetailUseCase
    private let addRecipeUseCase: AddRecipeUseCase
    private let setRecipeFavoriteUseCase: SetRecipeFavouriteUseCase
    private let deleteRecipeUseCase: DeleteRecipeUseCase
    private let getRecipeUseCase: GetRecipeUseCase
    
    // MARK: - Lifecycle
    
    init(exploreRecipe: ExploreMealSummaryDomainModel? = nil,
         exploreRecipeDetail: RecipeDomainModel? = nil,
         getExploreMealDetailUseCase: GetExploreMealDetailUseCase,
         addRecipeUseCase: AddRecipeUseCase,
         setRecipeFavoriteUseCase: SetRecipeFavouriteUseCase,
         deleteRecipeUseCase: DeleteRecipeUseCase,
         getRecipeUseCase: GetRecipeUseCase,
         coordinator: ExploreRecipeDetailCoordinatorProtocol) {
        self.exploreRecipe = exploreRecipe
        self.exploreRecipeDetail = exploreRecipeDetail
        self.getExploreMealDetailUseCase = getExploreMealDetailUseCase
        self.addRecipeUseCase = addRecipeUseCase
        self.setRecipeFavoriteUseCase = setRecipeFavoriteUseCase
        self.deleteRecipeUseCase = deleteRecipeUseCase
        self.getRecipeUseCase = getRecipeUseCase
        super.init(coordinator: coordinator)
    }
    
    override func onLoad() {
        super.onLoad()
        if let exploreRecipeDetail {
            isAdded = true
            parseToView()
        } else {
            getDetail()
        }
    }
    
    // MARK: - Internal functions
    
    func addToRecipe() {
        Task {
            do {
                if let exploreRecipeDetail {
                    try await addRecipeUseCase.execute(exploreRecipeDetail)
                    NotificationCenter.default.post(name: .updateList, object: nil)
                    print("✅ Success: Add explore recipe detail")
                    isAdded = true
                }
            } catch {
                print("❌ Error: Add explore recipe detail")
            }
        }
    }
    
    func setFavorite() {
        guard let exploreRecipeDetail else { return }
        
        Task {
            do {
                try await setRecipeFavoriteUseCase.execute(.init(id: exploreRecipeDetail.id,
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
    
    func deleteRecipe() {
        guard let exploreRecipeDetail else { return }
        
        Task {
            do {
                try await deleteRecipeUseCase.execute(exploreRecipeDetail.id)
                Task { @MainActor in
                    NotificationCenter.default.post(name: .updateList, object: nil)
                    isAdded = false
                }
            } catch {}
        }
        
    }
    
    // MARK: - Private functions
    
    private func getDetail() {
        Task {
            do {
                do {
                    exploreRecipeDetail = try await getRecipeUseCase.execute(exploreRecipe?.id)
                    Task { @MainActor in
                        isAdded = true
                    }
                } catch {
                    exploreRecipeDetail = try await getExploreMealDetailUseCase.execute(exploreRecipe?.id)
                    Task { @MainActor in
                        isAdded = false
                    }
                }
                print("✅ Success: Get explore recipe detail")
                parseToView()
                
            } catch {
                print("❌ Error: Get explore recipe detail")
            }
        }
    }
    
    private func parseToView() {
        Task { @MainActor in
            if let detail = exploreRecipeDetail {
                title = detail.title
                resources = detail.resources.compactMap({ $0.url })
                info = detail.extraInfo
                ingredients = detail.ingredients.compactMap({
                    .init(title: $0.name, quantity: $0.quantity)
                })
                preparation = detail.preparation
                links = detail.links.compactMap({ $0 })
            }
        }
    }
}

extension ExploreRecipeDetailViewModel {
    static let sample: ExploreRecipeDetailViewModel = {
        .init(exploreRecipe: .init(id: "", name: "", thumbnail: nil), 
              getExploreMealDetailUseCase: DependencyInjector.getExploreMealDetailUseCase(),
              addRecipeUseCase: DependencyInjector.addRecipeUseCase(),
              setRecipeFavoriteUseCase: DependencyInjector.setRecipeFavoriteUseCase(),
              deleteRecipeUseCase: DependencyInjector.deleteRecipeUseCase(),
              getRecipeUseCase: DependencyInjector.getRecipeUseCase(), 
              coordinator: ExploreCoordinator.sample)
    }()
}
