import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showSettingsView = false
    @State private var editingTransaction: Transaction?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                List {
                    ForEach(viewModel.groupedTransactions.keys.sorted(by: >), id: \.self) { monthDate in
                        Section(header: Text(monthDate, format: .dateTime.year().month().day()).font(.headline)) {
                            ForEach(viewModel.groupedTransactions[monthDate] ?? []) { transaction in
                                Button {
                                    editingTransaction = transaction
                                } label: {
                                    TransactionRowView(transaction: transaction, showTime: false)
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
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("履歴")
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
            .overlay {
                if viewModel.transactions.isEmpty {
                    ContentUnavailableView(
                        "履歴がありません", systemImage: "list.bullet.rectangle.portrait")
                }
            }
        }
    }
}
