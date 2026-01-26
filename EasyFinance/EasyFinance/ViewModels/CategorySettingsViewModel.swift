import Combine
import Foundation
import SwiftData
import SwiftUI

// CategorySettings ViewModel
@MainActor
class CategorySettingsViewModel: BaseViewModel {
    @Published private(set) var categories: [Category] = []

    override init(
        repository: FinanceRepository? = nil,
        errorHandler: ErrorHandlingServiceProtocol? = nil
    ) {
        let repo = repository ?? AppContainer.shared.repository
        let errorService = errorHandler ?? AppContainer.shared.errorHandlingService
        super.init(repository: repo, errorHandler: errorService)
        
        fetchData()
    }

    override func handleDataChanged() {
        fetchData()
    }

    private func fetchData() {
        do {
            self.categories = try repository.fetchAll()
        } catch {
            handleError(error, context: "CategorySettingsViewModel: Error fetching data")
        }
    }

    // MARK: - Category Logic
    func addCategory(name: String) {
        guard !name.isEmpty else { return }
        // Simple Logic: new category at end
        let newCategory = Category(
            name: name, iconSymbol: "tag", colorHex: "gray", sortOrder: categories.count)
        do {
            try repository.add(newCategory)
        } catch {
            handleError(error, context: "CategorySettingsViewModel: Failed to add category")
        }
    }

    func deleteCategory(category: Category) {
        do {
            try repository.delete(category)
        } catch {
            handleError(error, context: "CategorySettingsViewModel: Failed to delete category")
        }
    }
    
    func deleteCategory(at offsets: IndexSet) {
        offsets.forEach { index in
            guard index < categories.count else { return }
            let category = categories[index]
            deleteCategory(category: category)
        }
    }

    func moveCategory(from source: IndexSet, to destination: Int) {
        var updatedCategories = categories
        updatedCategories.move(fromOffsets: source, toOffset: destination)
        
        for (index, category) in updatedCategories.enumerated() {
            category.sortOrder = index
        }
        
        do {
            try repository.save()
        } catch {
            handleError(error, context: "CategorySettingsViewModel: Failed to save category order")
        }
        
        self.categories = updatedCategories
    }
}
