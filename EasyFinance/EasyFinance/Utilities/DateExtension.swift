import Foundation

/// Date拡張 - 日付関連のユーティリティメソッド
extension Date {
    /// 現在の月の初日を取得
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 指定された月の初日を取得
    static func startOfMonth(for date: Date = Date()) -> Date {
        return date.startOfMonth
    }
}

/// Calendar拡張 - 月の初日取得
extension Calendar {
    /// 指定された日付の月の初日を取得
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}
