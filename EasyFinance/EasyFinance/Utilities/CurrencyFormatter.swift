import Foundation

/// 通貨フォーマッター - 金額表示の統一的な処理
struct CurrencyFormatter {
    /// 金額を通貨形式でフォーマット
    /// - Parameters:
    ///   - amount: 金額
    ///   - showSymbol: 通貨記号を表示するか
    /// - Returns: フォーマットされた文字列
    static func format(_ amount: Int, showSymbol: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        let formattedNumber = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return showSymbol ? "¥\(formattedNumber)" : formattedNumber
    }
    
    /// 金額を簡潔な形式でフォーマット（千円単位など）
    /// - Parameter amount: 金額
    /// - Returns: フォーマットされた文字列
    static func formatCompact(_ amount: Int) -> String {
        if amount >= 10000 {
            let manAmount = Double(amount) / 10000.0
            return String(format: "¥%.1f万", manAmount)
        }
        return format(amount)
    }
}
