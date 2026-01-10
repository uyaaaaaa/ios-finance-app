import Combine
import Foundation
import SwiftUI

// Settings ViewModel
@MainActor
class SettingsViewModel: BaseViewModel {
    @Published private(set) var budgets: [Budget] = []
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
            self.budgets = try repository.fetchBudgets()
            self.categories = try repository.fetchAll()
        } catch {
            handleError(error, context: "SettingsViewModel: Error fetching data")
        }
    }

    // MARK: - Budget Logic
    var currentBudgetAmount: Int {
        budgets.first?.amount ?? 0
    }

    func saveBudget(amount: Int) {
        do {
            if let existing = budgets.first {
                existing.amount = amount
                try repository.save(existing)
            } else {
                let newBudget = Budget(amount: amount)
                try repository.save(newBudget)
            }
        } catch {
            handleError(error, context: "SettingsViewModel: Failed to save budget")
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
            handleError(error, context: "SettingsViewModel: Failed to add category")
        }
    }

    func deleteCategory(category: Category) {
        do {
            try repository.delete(category)
        } catch {
            handleError(error, context: "SettingsViewModel: Failed to delete category")
        }
    }
}
