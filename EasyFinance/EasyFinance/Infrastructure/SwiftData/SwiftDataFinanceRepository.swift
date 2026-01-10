import Combine
import Foundation
import SwiftData

class SwiftDataFinanceRepository: FinanceRepository {
    private let context: ModelContext

    // Publisher for data changes
    private let _dataChanged = PassthroughSubject<Void, Never>()
    var dataChanged: AnyPublisher<Void, Never> {
        _dataChanged.eraseToAnyPublisher()
    }

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Private Helpers
    
    private func performSave() throws {
        try context.save()
        _dataChanged.send()
    }

    // MARK: - CategoryRepository
    func fetchAll() throws -> [Category] {
        let descriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.sortOrder)])
        return try context.fetch(descriptor)
    }

    func find(byName name: String) throws -> Category? {
        let categories = try fetchAll()
        return categories.first { $0.name == name }
    }

    func add(_ category: Category) throws {
        context.insert(category)
        try performSave()
    }

    func delete(_ category: Category) throws {
        context.delete(category)
        try performSave()
    }

    func save() throws {
        try performSave()
    }

    // MARK: - TransactionRepository
    func fetchTransactions() throws -> [Transaction] {
        // Sort by date descending
        let descriptor = FetchDescriptor<Transaction>(sortBy: [
            SortDescriptor(\.date, order: .reverse)
        ])
        return try context.fetch(descriptor)
    }

    func add(_ transaction: Transaction) throws {
        context.insert(transaction)
        try performSave()
    }

    func delete(_ transaction: Transaction) throws {
        context.delete(transaction)
        try performSave()
    }

    func update(_ transaction: Transaction) throws {
        // SwiftDataでは既存オブジェクトのプロパティを変更してsaveするだけで更新できる
        try performSave()
    }

    // MARK: - BudgetRepository
    func fetchBudget() throws -> Budget? {
        let descriptor = FetchDescriptor<Budget>()
        return try context.fetch(descriptor).first
    }

    func fetchBudgets() throws -> [Budget] {
        let descriptor = FetchDescriptor<Budget>()
        return try context.fetch(descriptor)
    }

    func save(_ budget: Budget) throws {
        // If not inserted, insert. If inserted, just save context.
        context.insert(budget)
        try performSave()
    }
}
