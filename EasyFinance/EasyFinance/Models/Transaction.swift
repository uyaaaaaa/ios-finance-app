import Foundation
import SwiftData

@Model
final class Transaction {
    var amount: Int
    var date: Date
    var note: String?
    
    // Relationship can be optional or required depending on requirements.
    // Ideally every transaction should have a category.
    var category: Category?
    
    init(amount: Int, date: Date = Date(), note: String? = nil, category: Category? = nil) {
        self.amount = amount
        self.date = date
        self.note = note
        self.category = category
    }
}
