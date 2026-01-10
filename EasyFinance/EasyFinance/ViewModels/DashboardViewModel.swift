import Combine
import Foundation
import SwiftData
import SwiftUI

// Dashboard ViewModel
@MainActor
class DashboardViewModel: BaseViewModel {
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var budgets: [Budget] = []

    override init(
        repository: FinanceRepository? = nil,
        errorHandler: ErrorHandlingServiceProtocol? = nil
    ) {
        let repo = repository ?? AppContainer.shared.repository
        let errorService = errorHandler ?? AppContainer.shared.errorHandlingService
        super.init(repository: repo, errorHandler: errorService)
        
        // Initial Fetch
        fetchData()
    }

    override func handleDataChanged() {
        fetchData()
    }

    private func fetchData() {
        do {
            self.transactions = try repository.fetchTransactions()
            self.budgets = try repository.fetchBudgets()
        } catch {
            handleError(error, context: "DashboardViewModel: Error fetching data")
        }
    }

    // Calculate budget result for current month
    var budgetResult: BudgetCalculator.BudgetResult {
        let currentMonthTransactions = TransactionFilter.currentMonth(from: transactions)
        let budgetAmount = budgets.first?.amount ?? 50000
        return BudgetCalculator.calculate(
            transactions: currentMonthTransactions,
            budgetAmount: budgetAmount
        )
    }

    // Recent transactions (max: 10)
    var recentTransactions: [Transaction] {
        let currentMonth = TransactionFilter.currentMonth(from: transactions)
        return Array(currentMonth.prefix(10))
    }

    // All transactions for current month
    var currentMonthTransactions: [Transaction] {
        TransactionFilter.currentMonth(from: transactions)
    }
    
    /// トランザクションを削除
    func deleteTransaction(transaction: Transaction) {
        do {
            try repository.delete(transaction)
        } catch {
            handleError(error, context: "DashboardViewModel: Error deleting transaction")
        }
    }
}
