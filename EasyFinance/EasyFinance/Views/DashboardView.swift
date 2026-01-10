import SwiftUI
import SwiftData

struct DashboardView: View {
    // Removed @Query dependencies

    @StateObject private var viewModel = DashboardViewModel()
    @State private var showSettingsView = false
    @State private var editingTransaction: Transaction?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Budget Card
                    budgetCardView

                    // Recent Transactions Preview
                    recentTransactionsView

                    Spacer()
                }
                .padding(.top)

            }
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettingsView = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
            .sheet(item: $editingTransaction) { transaction in
                InputView(editingTransaction: transaction)
            }
            // Removed manual update logic on appear/change because ViewModel handles it now
        }
    }

    // MARK: - Subviews

    private var budgetCardView: some View {
        let result = viewModel.budgetResult
        return VStack(spacing: 16) {
            Text("予算残高")
                .font(.headline)
                .foregroundColor(.secondary)

            AmountDisplayView(
                amount: result.remainingAmount,
                style: .budget
            )
            .foregroundColor(result.isOverBudget ? .red : .primary)

            ProgressView(value: min(result.progress, 1.0))
                .tint(result.isOverBudget ? .red : .accentColor)
                .scaleEffect(y: 2)

            HStack {
                Text("支出: ¥\(result.totalSpent)")
                Spacer()
                Text("予算: ¥\(result.budgetAmount)")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding(24)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    private var recentTransactionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近の支出")
                .font(.headline)
                .padding(.horizontal)

            if viewModel.currentMonthTransactions.isEmpty {
                Text("まだ記録がありません")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
            } else {
                List {
                    ForEach(viewModel.recentTransactions) { transaction in
                        Button {
                            editingTransaction = transaction
                        } label: {
                            TransactionRowView(transaction: transaction, showTime: true)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteTransaction(transaction: transaction)
                                } label: {
                                    Label("", systemImage: "trash")
                                }
                            }
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(height: 300)
            }
        }
    }
}
