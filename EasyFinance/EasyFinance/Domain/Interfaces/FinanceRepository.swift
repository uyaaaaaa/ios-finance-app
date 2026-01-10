import Combine

protocol CategoryRepository {
    func fetchAll() throws -> [Category]
    func find(byName name: String) throws -> Category?
    func add(_ category: Category) throws
    func delete(_ category: Category) throws
    func save() throws  // Generic save for updates
}

protocol TransactionRepository {
    func fetchTransactions() throws -> [Transaction]
    func add(_ transaction: Transaction) throws
    func delete(_ transaction: Transaction) throws
    func update(_ transaction: Transaction) throws
}

protocol BudgetRepository {
    func fetchBudget() throws -> Budget?
    func fetchBudgets() throws -> [Budget]  // For list usage if needed
    func save(_ budget: Budget) throws
}

// Composition for convenience
protocol FinanceRepository: CategoryRepository, TransactionRepository, BudgetRepository {
    var dataChanged: AnyPublisher<Void, Never> { get }
}
