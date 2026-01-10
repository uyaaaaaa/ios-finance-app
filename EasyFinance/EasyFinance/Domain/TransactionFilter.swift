import Foundation
import SwiftData

/// トランザクションフィルタリングロジック - 共通処理の抽出
struct TransactionFilter {
    /// 当月のトランザクションをフィルタリング
    /// - Parameter transactions: 全トランザクション
    /// - Returns: 当月のトランザクション
    static func currentMonth(from transactions: [Transaction]) -> [Transaction] {
        let startOfMonth = Date.startOfMonth()
        return transactions.filter { $0.date >= startOfMonth }
    }
    
    /// 指定期間のトランザクションをフィルタリング
    /// - Parameters:
    ///   - transactions: 全トランザクション
    ///   - startDate: 開始日
    ///   - endDate: 終了日
    /// - Returns: 指定期間のトランザクション
    static func between(
        from transactions: [Transaction],
        startDate: Date,
        endDate: Date
    ) -> [Transaction] {
        return transactions.filter { transaction in
            transaction.date >= startDate && transaction.date <= endDate
        }
    }
    
    /// カテゴリでフィルタリング
    /// - Parameters:
    ///   - transactions: 全トランザクション
    ///   - category: カテゴリ
    /// - Returns: 指定カテゴリのトランザクション
    static func byCategory(
        from transactions: [Transaction],
        category: Category
    ) -> [Transaction] {
        return transactions.filter { $0.category?.id == category.id }
    }
    
    /// 日付でグループ化（日単位）
    /// - Parameter transactions: トランザクション配列
    /// - Returns: 日付（時刻なし）をキーとした辞書
    static func groupByDay(_ transactions: [Transaction]) -> [Date: [Transaction]] {
        return Dictionary(grouping: transactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }
    }

    /// 月でグループ化
    /// - Parameter transactions: トランザクション配列
    /// - Returns: 月の初日をキーとした辞書
    static func groupByMonth(_ transactions: [Transaction]) -> [Date: [Transaction]] {
        return Dictionary(grouping: transactions) { transaction in
            let components = Calendar.current.dateComponents([.year, .month], from: transaction.date)
            return Calendar.current.date(from: components) ?? Date()
        }
    }
}
