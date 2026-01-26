import SwiftUI

struct SettingsView: View {
    @State private var categoryMode: CategoryManagementMode = .none

    var body: some View {
        NavigationStack {
            List {
                BudgetSettingsView()

                CategoryListSettingsView(categoryMode: $categoryMode)

                Section("アプリについて") {
                    Text("Version 1.0.0 (MVP)")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.large)
            .environment(\.editMode, .constant(categoryMode == .editing ? .active : .inactive))
        }
    }
}
