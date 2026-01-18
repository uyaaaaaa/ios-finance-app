import SwiftUI

/// 再利用可能なカテゴリアイコン表示コンポーネント
struct CategoryIconView: View {
    let viewModel: CategoryIconViewModel
    
    init(iconSymbol: String, colorHex: String, size: CGFloat = 30, showCircleBackground: Bool = false) {
        self.viewModel = CategoryIconViewModel(
            iconSymbol: iconSymbol,
            colorHex: colorHex,
            size: size,
            showCircleBackground: showCircleBackground
        )
    }
    
    var body: some View {
        ZStack {
            if viewModel.showCircleBackground {
                Circle()
                    .fill(viewModel.circleColor)
                    .frame(width: viewModel.size, height: viewModel.size)
                
                Image(systemName: viewModel.iconSymbol)
                    .font(viewModel.iconFont)
                    .foregroundColor(viewModel.iconColor)
            } else {
                Image(systemName: viewModel.iconSymbol)
                    .font(viewModel.iconFont)
                    .foregroundColor(viewModel.iconColor)
                    .frame(width: viewModel.size, height: viewModel.size)
            }
        }
        .frame(width: viewModel.size, height: viewModel.size)
    }
}
