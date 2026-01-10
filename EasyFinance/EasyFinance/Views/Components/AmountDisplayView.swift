import SwiftUI

/// 金額表示スタイル
enum AmountDisplayStyle {
    case large  // 大きな表示（入力画面用）
    case compact  // コンパクト表示（リスト用）
    case budget  // 予算表示用
}

/// 再利用可能な金額表示コンポーネント
struct AmountDisplayView: View {
    let amount: Int
    let style: AmountDisplayStyle
    let showCurrency: Bool

    init(amount: Int, style: AmountDisplayStyle = .compact, showCurrency: Bool = true) {
        self.amount = amount
        self.style = style
        self.showCurrency = showCurrency
    }

    var body: some View {
        switch style {
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
            if showCurrency {
                Text("¥")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Text(CurrencyFormatter.format(amount, showSymbol: false))
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .frame(minWidth: 100)
                .fixedSize(horizontal: true, vertical: false)
        }
    }

    private var compactDisplay: some View {
        Text(CurrencyFormatter.format(amount, showSymbol: showCurrency))
            .font(.headline)
    }

    private var budgetDisplay: some View {
        Text(CurrencyFormatter.format(amount, showSymbol: showCurrency))
            .font(.system(size: 48, weight: .bold, design: .rounded))
    }
}
