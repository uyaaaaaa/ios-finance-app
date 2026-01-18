import SwiftUI

/// 金額表示スタイル
enum AmountDisplayStyle {
    case large  // 大きな表示（入力画面用）
    case compact  // コンパクト表示（リスト用）
    case budget  // 予算表示用
}

/// 再利用可能な金額表示コンポーネント
struct AmountDisplayView: View {
    let viewModel: AmountDisplayViewModel

    init(amount: Int, style: AmountDisplayStyle = .compact, showCurrency: Bool = true) {
        self.viewModel = AmountDisplayViewModel(amount: amount, style: style, showCurrency: showCurrency)
    }

    var body: some View {
        switch viewModel.style {
        case .large:
            largeDisplay
        case .compact:
            compactDisplay
        case .budget:
            budgetDisplay
        }
    }

    private var largeDisplay: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            if viewModel.shouldShowCurrencySymbol {
                Text("¥")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Text(viewModel.amountStringWithoutSymbol)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .frame(minWidth: 100)
                .fixedSize(horizontal: true, vertical: false)
        }
    }

    private var compactDisplay: some View {
        Text(viewModel.formattedAmount)
            .font(.headline)
    }

    private var budgetDisplay: some View {
        Text(viewModel.formattedAmount)
            .font(.system(size: 48, weight: .bold, design: .rounded))
    }
}
