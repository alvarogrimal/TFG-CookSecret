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
    
    // MARK: - Lifecycle
    
    override func onLoad() {
        super.onLoad()
        configurePublishers()
    }
    
    // MARK: - Internal functions
    
    // MARK: - Private functions
    
    private func configurePublishers() {
        $searchText
            .sink { [weak self] value in
                guard let self = self else { return }
                self.search(by: value)
            }
            .store(in: &cancellableSet)
    }
    
    private func search(by value: String) {
        print(value)
    }
}

// MARK: - Mock

extension RecipeListViewModel {
    static let sample: RecipeListViewModel = {
        .init(coordinator: RecipeCoordinator.sample)
    }()
}
