import SwiftUI

struct BudgetSettingsView: View {
    @StateObject private var viewModel = BudgetSettingsViewModel()
    @State private var budgetInput: String = ""
    @State private var isEditingBudget = false

    var body: some View {
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
