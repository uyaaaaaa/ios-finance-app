import SwiftUI

enum CategoryManagementMode {
    case none
    case editing
    case adding
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    @State private var budgetInput: String = ""
    @State private var isEditingBudget = false
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @State private var categoryMode: CategoryManagementMode = .none

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

                Section {
                    ForEach(viewModel.categories) { category in
                        HStack {
                            CategoryIconView(
                                iconSymbol: category.iconSymbol,
                                colorHex: category.colorHex,
                                size: 30
                            )
                            Text(category.name)
                            Spacer()
                        }
                    }
                    .onDelete { indices in
                        viewModel.deleteCategory(at: indices)
                    }
                    .onMove { indices, newOffset in
                        viewModel.moveCategory(from: indices, to: newOffset)
                    }
                    .deleteDisabled(categoryMode != .editing)
                    .moveDisabled(categoryMode != .editing)
                } header: {
                    HStack {
                        Text("カテゴリ管理")
                        Spacer()
                        Menu {
                            Button {
                                categoryMode = .editing
                            } label: {
                                Label("編集", systemImage: "pencil")
                            }
                            Button {
                                categoryMode = .adding
                                showingAddCategory = true
                            } label: {
                                Label("追加", systemImage: "plus")
                            }

                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                    }
                    .textCase(nil)
                }

                Section("アプリについて") {
                    Text("Version 1.0.0 (MVP)")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
            .environment(\.editMode, .constant(categoryMode == .editing ? .active : .inactive))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if categoryMode == .editing {
                        Button("完了") {
                            categoryMode = .none
                        }
                    }
                }
            }
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
