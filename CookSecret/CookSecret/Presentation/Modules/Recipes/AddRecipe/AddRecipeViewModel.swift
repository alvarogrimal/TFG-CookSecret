//
//  AddRecipeViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import UIKit

enum RecipeType: String, CaseIterable {
    case starter, principal, secondary, dessert
    
    func getValue() -> String {
        switch self {
        case .starter:
            "starter".localized
        case .principal:
            "principal".localized
        case .secondary:
            "secondary".localized
        case .dessert:
            "dessert".localized
        }
    }
}

struct RecipeResourceViewModel: Identifiable {
    let id: String
    var data: Data
    
    init(data: Data) {
        self.id = UUID().uuidString
        self.data = data
    }
}

struct RecipeIngredientViewModel: Identifiable {
    let id: String
    let title: String
    let quantity: String
    
    init(title: String,
         quantity: String) {
        self.id = UUID().uuidString
        self.title = title
        self.quantity = quantity
    }
}

final class AddRecipeViewModel: BaseViewModel<AddRecipeCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var timer: TimerViewModel = .init()
    @Published var people: Int = 1
    @Published var type: RecipeType = RecipeType.starter
    @Published var typeValue: String = RecipeType.starter.getValue() {
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
                type = RecipeType.starter
            }
        }
    }
    @Published var ingredients: [RecipeIngredientViewModel] = []
    @Published var preparation: String = ""
    @Published var resources: [RecipeResourceViewModel] = []
    
    private let galleryManager = GalleryManager()
    private let cameraManager = CameraManager()
    private let addRecipeUseCase: AddRecipeUseCase
    var resourcesList: [RecipeResourceViewModel] = []
    
    // MARK: - Lifecycle
    
    init(addRecipeUseCase: AddRecipeUseCase,
         coordinator: BaseCoordinatorProtocol) {
        self.addRecipeUseCase = addRecipeUseCase
        super.init(coordinator: coordinator)
        galleryManager.delegate = self
        cameraManager.delegate = self
    }
    
    override func onAppear() {
        super.onAppear()
        Task { @MainActor in
            resources = resourcesList
        }
    }
    
    // MARK: - Internal functions
    
    func getPeopleText() -> String {
        String(format: people == 1 ?
               "add_recipe_person_format".localized :
                "add_recipe_people_format".localized,
               people)
    }

    func deleteResource(id: String) {
        resources.removeAll(where: { $0.id == id })
    }
    
    func openGallery() {
        guard let topVC = UIApplication.shared.getTopVC() else { return }
        galleryManager.openGallery(viewController: topVC,
                                   cancelTitle: "general_cancel".localized)
    }
    
    func openCamera() {
        guard let topVC = UIApplication.shared.getTopVC() else { return }
        cameraManager.openCamera(viewController: topVC,
                                 cancelTitle: "general_cancel".localized)
    }
    
    func save() async {
        await addRecipe()
    }
    
    func checkSaveIsEnable() -> Bool {
        !title.isEmpty && !description.isEmpty && !preparation.isEmpty
    }
    
    func deleteIngredient(at offsets: IndexSet) {
        ingredients.remove(atOffsets: offsets)
    }
    
    func addIngredient() {
        getCoordinator()?.addIngredient(delegate: self)
    }
    
    // MARK: - Private functions

    private func addRecipe() async {
        do {
            try await addRecipeUseCase.execute(getDomainRecipe())
            print("✅ Success: Added recipe")
        } catch {
            print("❌ Error: Added recipe")
        }
    }
    
    private func getDomainRecipe() -> RecipeDomainModel {
        .init(title: title,
              type: type.rawValue,
              description: description,
              people: people,
              preparation: preparation,
              dateUpdated: .now,
              time: getTimeDouble(),
              ingredients: ingredients.compactMap({ .init(id: $0.id,
                                                          name: $0.title,
                                                          quantity: $0.quantity) }),
              extraInfo: [],
              resources: resourcesList.compactMap({ .init(id: $0.id,
                                                          image: $0.data) }))
    }
    
    private func getTimeDouble() -> Double {
        Double(timer.selectedHoursAmount * 3600 + 
               timer.selectedMinutesAmount * 60 +
               timer.selectedSecondsAmount)
    }
}

// MARK: - AddIngredientDelegate

extension AddRecipeViewModel: AddIngredientDelegate {
    
    func addIngredient(_ ingredient: RecipeIngredientViewModel) {
        ingredients.append(ingredient)
    }
}

// MARK: - ImageManagerDelegate

extension AddRecipeViewModel: ImageManagerDelegate {
    func pictureTaken(_ imageData: Data, completion: @escaping () -> Void) {
        let resource = RecipeResourceViewModel(data: imageData)
        resourcesList.append(resource)
        completion()
    }
}

// MARK: - Mock

extension AddRecipeViewModel {
    static let sample: AddRecipeViewModel = {
        .init(addRecipeUseCase: DependencyInjector.addRecipeUseCase(),
              coordinator: RecipeCoordinator.sample)
    }()
}
