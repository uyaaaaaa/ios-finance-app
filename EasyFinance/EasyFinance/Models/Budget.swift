import Foundation
import SwiftData

@Model
final class Budget {
    // Only one budget record is expected for MVP (Monthly Budget)
    // We can use a singleton-like pattern or just fetch the first one.
    var id: String // Fixed ID to ensure singleton
    var amount: Int
    
    init(amount: Int = 50000) {
        self.id = "monthly_budget"
        self.amount = amount
    }
}
