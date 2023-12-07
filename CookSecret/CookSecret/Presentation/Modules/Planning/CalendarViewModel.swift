//
//  CalendarViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 5/12/23.
//

import FSCalendar

struct CalendarItemViewModel {
    let date: Date
    var items: [RecipeListItemViewModel]
}

final class CalendarViewModel: BaseViewModel<CalendarCoordinatorProtocol> {
    
    // MARK: - Properties
    
    @Published var calendar = FSCalendar()
    @Published var selectedDate = Calendar.current.startOfDay(for: .now)
    @Published var recipesPerDate: [CalendarItemViewModel] = []
    
    private let getPlanningUseCase: GetPlanningUseCase
    private let deletePlannedRecipeUseCase: DeletePlannedRecipeUseCase
    private let setPlannedRecipesUseCase: SetPlannedRecipesUseCase
    private var domainPlanning: [PlanningItemDomainModel] = []
    
    // MARK: - Lifecycle
    
    init(getPlanningUseCase: GetPlanningUseCase,
         deletePlannedRecipeUseCase: DeletePlannedRecipeUseCase,
         setPlannedRecipesUseCase: SetPlannedRecipesUseCase,
         coordinator: BaseCoordinatorProtocol) {
        self.getPlanningUseCase = getPlanningUseCase
        self.deletePlannedRecipeUseCase = deletePlannedRecipeUseCase
        self.setPlannedRecipesUseCase = setPlannedRecipesUseCase
        super.init(coordinator: coordinator)

        getPlanning()
    }
    
    // MARK: - Internal functions
    
    func todayTapped() {
        selectedDate = Calendar.current.startOfDay(for: .now)
        calendar.setCurrentPage(.init(), animated: true)
        calendar.select(selectedDate)
    }
    
    func openRecipesPicker() {
        getCoordinator()?.openRecipesPicker(delegate: self)
    }
    
    func getItems() -> [RecipeListItemViewModel] {
        if let calendarItem = recipesPerDate.first(where: { $0.date == selectedDate }) {
            return calendarItem.items
        }
        return []
    }
    
    func refresh() {
        getPlanning()
    }
    
    func delete(recipeId: String) {
        Task {
            do {
                try await deletePlannedRecipeUseCase.execute(.init(recipeId: recipeId,
                                                                   date: selectedDate))
                print("✅ Success: Delete recipe at date")
                getPlanning()
            } catch {
                print("❌ Error: Delete recipe at date")
            }
        }
    }
    
    // MARK: - Private functions
    
    private func getPlanning() {
        Task {
            do {
                domainPlanning = try await getPlanningUseCase.execute() ?? []
                print("✅ Success: Get planning")
                
                Task { @MainActor in
                    recipesPerDate = domainPlanning.compactMap({ item in
                            .init(date: item.date,
                                  items: item.recipes
                                .compactMap({
                                    .init(id: $0.id,
                                          title: $0.title,
                                          image: $0.resources.first?.image ?? .init(),
                                          thumbnailURL: $0.resources.first?.url)
                                }))
                    })
                    calendar.reloadData()
                }
            } catch {
                print("❌ Error: Get planning")
            }
        }
    }
}

// MARK: - RecipeListPickerDelegate

extension CalendarViewModel: RecipeListPickerDelegate {
    func add(recipes: [RecipeDomainModel]) {
        Task {
            do {
                try await setPlannedRecipesUseCase.execute(.init(recipes: recipes,
                                                                 date: selectedDate))
                getPlanning()
                print("✅ Success: Add recipe at date")
            } catch {
                print("❌ Error: Add recipe at date")
            }
        }
    }
}

// MARK: - Mock

extension CalendarViewModel {
    static let sample: CalendarViewModel = {
        DependencyInjector.calendarViewModel(coordinator: CalendarCoordinator.sample)
    }()
}
