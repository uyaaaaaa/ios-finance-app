import SwiftUI
import Combine

@MainActor
class AmountDisplayViewModel: ObservableObject {
    let amount: Int
    let style: AmountDisplayStyle
    let showCurrency: Bool
    
    init(amount: Int, style: AmountDisplayStyle, showCurrency: Bool) {
        self.amount = amount
        self.style = style
        self.showCurrency = showCurrency
    }
    
    var formattedAmount: String {
        CurrencyFormatter.format(amount, showSymbol: showCurrency)
    }
    
    var amountStringWithoutSymbol: String {
        CurrencyFormatter.format(amount, showSymbol: false)
    }
    
    var shouldShowCurrencySymbol: Bool {
        showCurrency
    }
    
    // MARK: - Style Helpers
    
    var isLarge: Bool {
        style == .large
    }
    
    var isCompact: Bool {
        style == .compact
    }
    
    var isBudget: Bool {
        style == .budget
    }
}
