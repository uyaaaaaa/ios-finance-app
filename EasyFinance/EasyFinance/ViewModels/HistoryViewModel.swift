import Combine
import Foundation
import SwiftData
import SwiftUI

// History ViewModel
@MainActor
class HistoryViewModel: BaseViewModel {
    @Published private(set) var transactions: [Transaction] = []

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
            self.transactions = try repository.fetchTransactions()
        } catch {
            handleError(error, context: "HistoryViewModel: Error fetching data")
        }
    }

    var groupedTransactions: [Date: [Transaction]] {
        TransactionFilter.groupByDay(transactions)
    }

    // Delete transaction
    func deleteTransaction(transaction: Transaction) {
        do {
            try repository.delete(transaction)
        } catch {
            handleError(error, context: "HistoryViewModel: Error deleting transaction")
        }
    }

    // Update transaction
    func updateTransaction(transaction: Transaction, amount: Int, category: Category, date: Date) {
        do {
            transaction.amount = amount
            transaction.category = category
            transaction.date = date
            try repository.update(transaction)
        } catch {
            handleError(error, context: "HistoryViewModel: Error updating transaction")
        }
    }
}
