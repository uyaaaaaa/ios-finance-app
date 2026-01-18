import SwiftUI
import Combine

/// CategoryIconViewの表示ロジックを管理するViewModel
@MainActor
class CategoryIconViewModel: ObservableObject {
    let iconSymbol: String
    let colorHex: String
    let size: CGFloat
    let showCircleBackground: Bool
    
    init(iconSymbol: String, colorHex: String, size: CGFloat, showCircleBackground: Bool) {
        self.iconSymbol = iconSymbol
        self.colorHex = colorHex
        self.size = size
        self.showCircleBackground = showCircleBackground
    }
    
    // MARK: - Logic
    
    /// アイコン自体の色
    var iconColor: Color {
        showCircleBackground ? .white : Color(colorHex)
    }
    
    /// 背景円の色
    var circleColor: Color {
        Color(colorHex)
    }
    
    /// アイコンのフォントサイズ
    var iconFontSize: CGFloat {
        if showCircleBackground {
            return size * 0.5
        } else {
            return size * 0.8
        }
    }
    
    /// アイコンのウェイト（背景ありの場合は太くする）
    var iconFontWeight: Font.Weight {
        if showCircleBackground {
            return .semibold
        } else {
            return .regular // 背景なしの場合はデフォルト（必要に応じて調整）
        }
    }
    
    /// Fontオブジェクトを返すヘルパー
    var iconFont: Font {
        if showCircleBackground {
            return .system(size: iconFontSize, weight: .semibold)
        } else {
            return .system(size: iconFontSize)
        }
    }
}
