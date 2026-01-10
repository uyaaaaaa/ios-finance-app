import SwiftUI

/// Color拡張 - 文字列からColorへの変換
/// DashboardViewから抽出して独立ファイルに移動
extension Color {
    /// 色名文字列からColorを生成
    /// - Parameter name: 色名（"blue", "green"など）
    init(_ name: String) {
        switch name {
        case "blue": self = .blue
        case "green": self = .green
        case "orange": self = .orange
        case "red": self = .red
        case "purple": self = .purple
        case "pink": self = .pink
        case "yellow": self = .yellow
        case "indigo": self = .indigo
        case "gray": self = .gray
        default: self = .gray
        }
    }
}
