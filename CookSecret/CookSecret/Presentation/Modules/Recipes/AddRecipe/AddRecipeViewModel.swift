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
            "add_recipe_starter".localized
        case .principal:
            "add_recipe_principal".localized
        case .secondary:
            "add_recipe_secondary".localized
        case .dessert:
            "add_recipe_dessert".localized
        }
    }
}

struct RecipeResourceViewModel: Identifiable {
    let id: String
    var data: Data
    
    init(id: String = UUID().uuidString, data: Data) {
        self.id = id
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

protocol EditRecipeDelegate: AnyObject {
    func editRecipeCompleted() async throws
}

final class AddRecipeViewModel: BaseViewModel<AddRecipeCoordinatorProtocol> {
    
    // MARK: - Properties
    
    var isEditingMode: Bool = false
    var editDomainId: String?
    var viewTitle: String = "add_recipe_nav_title".localized
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
    private let editRecipeUseCase: EditRecipeUseCase
    var resourcesList: [RecipeResourceViewModel] = []
    private weak var editDelegate: EditRecipeDelegate?
    
    // MARK: - Lifecycle
    
    init(addRecipeUseCase: AddRecipeUseCase,
         editRecipeUseCase: EditRecipeUseCase,
         type: AddRecipeCoordinator.AddRecipeType,
         coordinator: BaseCoordinatorProtocol) {
        self.addRecipeUseCase = addRecipeUseCase
        self.editRecipeUseCase = editRecipeUseCase
        switch type {
        case .edit(let domainModel, let delegate):
            editDomainId = domainModel.id
            editDelegate = delegate
            viewTitle = "edit_recipe_title".localized
            title = domainModel.title
            description = domainModel.description
            timer = .init(value: domainModel.time)
            people = domainModel.people
            self.typeValue = RecipeType(rawValue: domainModel.type ?? "")?.rawValue ?? ""
            ingredients = domainModel.ingredients.map({ .init(title: $0.name,
                                                              quantity: $0.quantity) })
            preparation = domainModel.preparation
            resources = domainModel.resources.map({ .init(id: $0.id,
                                                          data: $0.image) })
            resourcesList = domainModel.resources.map({ .init(id: $0.id,
                                                              data: $0.image) })
            isEditingMode = true
        default: break
        }
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
        NotificationCenter.default.post(name: .updateList, object: nil)
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
            if isEditingMode {
                let domain = getDomainRecipe()
                try await editRecipeUseCase.execute(domain)
                try await editDelegate?.editRecipeCompleted()
                print("✅ Success: Edited recipe")
            } else {
                try await addRecipeUseCase.execute(getDomainRecipe())
                print("✅ Success: Added recipe")
            }
        } catch {
            if isEditingMode {
                
            } else {
                print("❌ Error: Added recipe")
            }
        }
    }
    
    private func getDomainRecipe() -> RecipeDomainModel {
        .init(id: editDomainId ?? UUID().uuidString,
              title: title,
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
              editRecipeUseCase: DependencyInjector.editRecipeUseCase(),
              type: .add,
              coordinator: RecipeCoordinator.sample)
    }()
}
