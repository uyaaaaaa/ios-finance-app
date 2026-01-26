import Combine
import Foundation
import SwiftData
import SwiftUI

// BudgetSettings ViewModel
@MainActor
class BudgetSettingsViewModel: BaseViewModel {
    @Published private(set) var budgets: [Budget] = []

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
        } catch {
            handleError(error, context: "BudgetSettingsViewModel: Error fetching data")
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
            handleError(error, context: "BudgetSettingsViewModel: Failed to save budget")
        }
    }
}
