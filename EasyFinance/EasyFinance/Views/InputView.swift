import SwiftUI

struct InputView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: InputViewModel
    
    private let isEditingMode: Bool
    
    init(editingTransaction: Transaction? = nil) {
        let vm = InputViewModel(editingTransaction: editingTransaction)
        _viewModel = StateObject(wrappedValue: vm)
        self.isEditingMode = editingTransaction != nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 1. Amount Input
                Spacer()
                if isEditingMode {
                    ZStack {
                        // 表示用UI (タップ判定を無効化して背後のDatePickerに届ける)
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                            Text(viewModel.transactionDate, style: .date)
                                .fontWeight(.semibold)
                        }
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Capsule())
                        .foregroundColor(.secondary)
                        .allowsHitTesting(false)
                        
                        // 判定用DatePicker (透明だが、スケールを上げてカプセル全体をカバー)
                        DatePicker(
                            "",
                            selection: $viewModel.transactionDate,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        .opacity(0.011)
                        .scaleEffect(x: 2.0, y: 1.2) // 横幅と高さをカプセルに合わせる
                        .clipped()
                        .environment(\.locale, Locale(identifier: "ja_JP"))
                    }
                }

                AmountDisplayView(
                    amount: Int(viewModel.inputAmount) ?? 0,
                    style: .large
                )
                .padding(.horizontal)

                // 2. Category Selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.categories) { category in
                            CategorySelectionCell(
                                category: category,
                                isSelected: viewModel.selectedCategory?.id == category.id,
                                onTap: { viewModel.selectedCategory = category }
                            )
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
                .frame(height: 100)

                // 3. Keypad
                KeypadView(
                    text: $viewModel.inputAmount,
                    isDoneDisabled: viewModel.isSaveDisabled,
                    onCommit: {
                        saveTransaction()
                    }
                )
                .background(Color(UIColor.systemBackground))
            }
            .padding(.bottom)
            .navigationTitle(isEditingMode ? "編集" : "入力")
            .navigationBarTitleDisplayMode(.inline)
            // Toolbar adjustments
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Logic

    private func saveTransaction() {
        viewModel.saveTransaction {
            // Taptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            dismiss()
        }
    }
}

// MARK: - Subcomponents

struct CategorySelectionCell: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack {
                CategoryIconView(
                    iconSymbol: category.iconSymbol,
                    colorHex: category.colorHex,
                    size: 50,
                    showCircleBackground: isSelected
                )

                Text(category.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring, value: isSelected)
    }
}
