import Foundation
import SwiftData
import Combine

/// 日付フォーマットの戦略を定義するプロトコル
protocol DateFormattingStrategy {
    func formatDate(_ date: Date) -> String
}

/// 日付と時間を表示する戦略 (例: 10/25/2023, 10:30 AM)
struct DateTimeStrategy: DateFormattingStrategy {
    func formatDate(_ date: Date) -> String {
        return date.formatted(date: .numeric, time: .shortened)
    }
}

/// 時間のみを表示する戦略 (例: 10:30 AM)
struct TimeOnlyStrategy: DateFormattingStrategy {
    func formatDate(_ date: Date) -> String {
        return date.formatted(date: .omitted, time: .shortened)
    }
}

/// TransactionRowView用のViewModel
final class TransactionRowViewModel: ObservableObject {
    let transaction: Transaction
    private let dateStrategy: DateFormattingStrategy
    
    init(transaction: Transaction, dateStrategy: DateFormattingStrategy) {
        self.transaction = transaction
        self.dateStrategy = dateStrategy
    }
    
    var categoryName: String {
        transaction.category?.name ?? "未分類"
    }
    
    var categoryIconSymbol: String {
        transaction.category?.iconSymbol ?? "questionmark.circle"
    }
    
    var categoryColorHex: String {
        transaction.category?.colorHex ?? "#808080"
    }
    
    var amount: Int {
        transaction.amount
    }
    
    var formattedDate: String {
        dateStrategy.formatDate(transaction.date)
    }
}
