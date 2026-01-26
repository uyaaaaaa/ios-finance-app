import SwiftUI

enum CategoryManagementMode {
    case none
    case editing
    case adding
}

struct CategoryListSettingsView: View {
    @StateObject private var viewModel = CategorySettingsViewModel()
    @State private var showingAddCategory = false
    @State private var newCategoryName = ""
    @Binding var categoryMode: CategoryManagementMode

    var body: some View {
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
                if categoryMode == .editing {
                    Button {
                        categoryMode = .none
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                } else {
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
            }
            .textCase(nil)
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
