import SwiftUI

// 取引明細の表示用コンポーネント
struct TransactionRowView: View {
    let transaction: Transaction
    let showTime: Bool
    
    init(transaction: Transaction, showTime: Bool = true) {
        self.transaction = transaction
        self.showTime = showTime
    }
    
    var body: some View {
        HStack {
            // Category Icon
            if let category = transaction.category {
                CategoryIconView(
                    iconSymbol: category.iconSymbol,
                    colorHex: category.colorHex,
                    size: 30
                )
            }
            
            // Transaction Info
            VStack(alignment: .leading) {
                Text(transaction.category?.name ?? "未分類")
                    .font(.headline)
                
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            AmountDisplayView(
                amount: transaction.amount,
                style: .compact
            )
        }
    }
    
    private var formattedDate: String {
        if showTime {
            return transaction.date.formatted(date: .numeric, time: .shortened)
        } else {
            return transaction.date.formatted(date: .omitted, time: .shortened)
        }
    }
}
