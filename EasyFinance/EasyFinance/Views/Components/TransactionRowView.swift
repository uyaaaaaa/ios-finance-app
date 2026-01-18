import SwiftUI

// 取引明細の表示用コンポーネント
struct TransactionRowView: View {
    @StateObject private var viewModel: TransactionRowViewModel
    
    init(transaction: Transaction, dateStrategy: DateFormattingStrategy) {
        _viewModel = StateObject(wrappedValue: TransactionRowViewModel(transaction: transaction, dateStrategy: dateStrategy))
    }
    
    var body: some View {
        HStack {
            // Category Icon
            CategoryIconView(
                iconSymbol: viewModel.categoryIconSymbol,
                colorHex: viewModel.categoryColorHex,
                size: 30
            )
            
            // Transaction Info
            VStack(alignment: .leading) {
                Text(viewModel.categoryName)
                    .font(.headline)
                
                Text(viewModel.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            AmountDisplayView(
                amount: viewModel.amount,
                style: .compact
            )
        }
    }
}
