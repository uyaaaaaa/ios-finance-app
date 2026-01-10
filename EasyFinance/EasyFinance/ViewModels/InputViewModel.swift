import Combine
import Foundation
import SwiftData
import SwiftUI

// Input ViewModel
@MainActor
class InputViewModel: BaseViewModel {
    @Published private(set) var categories: [Category] = []
    @Published var selectedCategory: Category?
    @Published var inputAmount: String = ""
    @Published var transactionDate: Date = Date()

    private let saveStrategy: TransactionSaveStrategy

    init(
        repository: FinanceRepository? = nil,
        errorHandler: ErrorHandlingServiceProtocol? = nil,
        editingTransaction: Transaction? = nil
    ) {
        let strategy = TransactionSaveStrategyFactory.create(for: editingTransaction)
        
        let repo = repository ?? AppContainer.shared.repository
        let errorService = errorHandler ?? AppContainer.shared.errorHandlingService
        self.saveStrategy = strategy
        super.init(repository: repo, errorHandler: errorService)

        fetchData()
        
        // Set existing values if in edit mode
        if let transaction = editingTransaction {
            self.inputAmount = String(transaction.amount)
            self.selectedCategory = transaction.category
            self.transactionDate = transaction.date
        }
    }

    override func handleDataChanged() {
        fetchData()
    }

    private func fetchData() {
        do {
            self.categories = try repository.fetchAll()
            // Set default selection if needed and not set
            if selectedCategory == nil {
                selectedCategory = categories.first
            }
        } catch {
            handleError(error, context: "InputViewModel: Error fetching data")
        }
    }

    func saveTransaction(completion: () -> Void) {
        guard let amount = Int(inputAmount), amount > 0, let category = selectedCategory else {
            return
        }

        do {
            try saveStrategy.save(amount: amount, category: category, date: transactionDate, repository: repository)
            completion()
        } catch {
            handleError(error, context: "InputViewModel: Failed to save")
        }
    }

    var isSaveDisabled: Bool {
        (Int(inputAmount) ?? 0) <= 0 || selectedCategory == nil
    }
}
