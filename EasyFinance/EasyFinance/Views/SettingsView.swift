import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    @State private var budgetInput: String = ""
    @State private var isEditingBudget = false

    @State private var showingAddCategory = false
    @State private var newCategoryName = ""

    var body: some View {
        NavigationStack {
            List {
                Section("予算設定") {
                    HStack {
                        Text("月間予算")
                        Spacer()
                        if isEditingBudget {
                            TextField("金額", text: $budgetInput)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .onSubmit {
                                    saveBudget()
                                }
                            Button("完了") {
                                saveBudget()
                            }
                        } else {
                            Text(CurrencyFormatter.format(viewModel.currentBudgetAmount))
                                .onTapGesture {
                                    startEditingBudget()
                                }
                        }
                    }
                }

                Section("カテゴリ管理") {
                    ForEach(viewModel.categories) { category in
                        HStack {
                            CategoryIconView(
                                iconSymbol: category.iconSymbol,
                                colorHex: category.colorHex,
                                size: 30
                            )
                            Text(category.name)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteCategory(category: category)
                                    } label: {
                                        Label("", systemImage: "trash")
                                    }
                                }
                        }
                    }

                    Button {
                        showingAddCategory = true
                    } label: {
                        Label("カテゴリを追加", systemImage: "plus")
                    }
                }

                Section("アプリについて") {
                    Text("Version 1.0.0 (MVP)")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.large)
            .alert("カテゴリ追加", isPresented: $showingAddCategory) {
                TextField("カテゴリ名", text: $newCategoryName)
                Button("追加") {
                    viewModel.addCategory(name: newCategoryName)
                    newCategoryName = ""
                }
                Button("キャンセル", role: .cancel) {}
            }
        }
    }

    private func startEditingBudget() {
        budgetInput = String(viewModel.currentBudgetAmount)
        isEditingBudget = true
    }

    private func saveBudget() {
        guard let amount = Int(budgetInput) else { return }
        viewModel.saveBudget(amount: amount)
        isEditingBudget = false
    }
}
