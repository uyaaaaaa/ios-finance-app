import Foundation

protocol DataSeedingServiceProtocol {
    func seedDataIfNeeded()
}

class DataSeedingService: DataSeedingServiceProtocol {
    private let repository: FinanceRepository

    init(repository: FinanceRepository) {
        self.repository = repository
    }

    func seedDataIfNeeded() {
        // Check if categories exist
        guard let categories = try? repository.fetchAll(), categories.isEmpty else { return }

        // Add defaults
        for category in Category.defaults {
            try? repository.add(category)
        }

        // Add default budget if needed
        if (try? repository.fetchBudget()) == nil {
            try? repository.save(Budget(amount: 50000))
        }
    }
}
