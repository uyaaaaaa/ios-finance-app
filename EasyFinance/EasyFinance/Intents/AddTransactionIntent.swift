import AppIntents
import SwiftData
import Foundation

struct AddTransactionIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Transaction"
    static var description = IntentDescription("Adds a new transaction to the Finance App.")
    
    @Parameter(title: "Amount")
    var amount: Int
    
    @Parameter(title: "Category")
    var categoryName: String?
    
    // Note: ideally we would use a dynamic entity for Category, but for MVP keeping it simple string matching
    // or we can try to fetch category from DB.
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let repository = AppContainer.shared.repository
        
        // Find or default category
        let categories = try? repository.fetchAll()
        
        var selectedCategory: Category? = nil
        if let name = categoryName, let found = try? repository.find(byName: name) {
            selectedCategory = found
        } else {
             selectedCategory = categories?.first
        }
        
        let transaction = Transaction(amount: amount, category: selectedCategory)
        
        do {
            try repository.add(transaction)
            return .result(value: "Saved \(amount) to \(selectedCategory?.name ?? "Unknown")")
        } catch {
             return .result(value: "Failed to save: \(error.localizedDescription)")
        }
    }
}
