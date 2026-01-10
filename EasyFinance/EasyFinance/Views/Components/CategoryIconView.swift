import SwiftUI

/// 再利用可能なカテゴリアイコン表示コンポーネント
struct CategoryIconView: View {
    let iconSymbol: String
    let colorHex: String
    let size: CGFloat
    let showCircleBackground: Bool
    
    init(iconSymbol: String, colorHex: String, size: CGFloat = 30, showCircleBackground: Bool = false) {
        self.iconSymbol = iconSymbol
        self.colorHex = colorHex
        self.size = size
        self.showCircleBackground = showCircleBackground
    }
    
    var body: some View {
        ZStack {
            if showCircleBackground {
                Circle()
                    .fill(Color(colorHex))
                    .frame(width: size, height: size)
                
                Image(systemName: iconSymbol)
                    .font(.system(size: size * 0.5, weight: .semibold))
                    .foregroundColor(.white)
            } else {
                Image(systemName: iconSymbol)
                    .font(.system(size: size * 0.8))
                    .foregroundColor(Color(colorHex))
                    .frame(width: size, height: size)
            }
        }
        .frame(width: size, height: size)
    }
}
