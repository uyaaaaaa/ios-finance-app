import Foundation

/// 予算計算ロジック - Viewから分離してテスタビリティを向上
struct BudgetCalculator {
    /// 予算計算結果
    struct BudgetResult {
        let totalSpent: Int
        let budgetAmount: Int
        let remainingAmount: Int
        let progress: Double
        let isOverBudget: Bool
    }
    
    /// トランザクションと予算から計算結果を生成
    /// - Parameters:
    ///   - transactions: トランザクション配列
    ///   - budgetAmount: 予算額
    /// - Returns: 予算計算結果
    static func calculate(transactions: [Transaction], budgetAmount: Int) -> BudgetResult {
        let totalSpent = transactions.reduce(0) { $0 + $1.amount }
        let remainingAmount = budgetAmount - totalSpent
        let progress = budgetAmount > 0 ? Double(totalSpent) / Double(budgetAmount) : 0
        let isOverBudget = remainingAmount < 0
        
        return BudgetResult(
            totalSpent: totalSpent,
            budgetAmount: budgetAmount,
            remainingAmount: remainingAmount,
            progress: progress,
            isOverBudget: isOverBudget
        )
    }
}
