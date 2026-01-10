import Foundation

protocol TransactionSaveStrategy {
    func save(amount: Int, category: Category, date: Date, repository: FinanceRepository) throws
}

struct CreateTransactionStrategy: TransactionSaveStrategy {
    func save(amount: Int, category: Category, date: Date, repository: FinanceRepository) throws {
        let transaction = Transaction(amount: amount, date: date, category: category)
        try repository.add(transaction)
    }
}

struct UpdateTransactionStrategy: TransactionSaveStrategy {
    let transaction: Transaction
    
    func save(amount: Int, category: Category, date: Date, repository: FinanceRepository) throws {
        transaction.amount = amount
        transaction.category = category
        transaction.date = date
        try repository.update(transaction)
    }
}

// Factory
struct TransactionSaveStrategyFactory {
    static func create(for transaction: Transaction?) -> TransactionSaveStrategy {
        if let transaction = transaction {
            return UpdateTransactionStrategy(transaction: transaction)
        } else {
            return CreateTransactionStrategy()
        }
    }
}
