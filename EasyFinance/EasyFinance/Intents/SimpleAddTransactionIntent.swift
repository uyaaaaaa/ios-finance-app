import AppIntents
import SwiftData
import Foundation

struct SimpleAddTransactionIntent: AppIntent {
    static var title: LocalizedStringResource = "クイック記録"
    static var description = IntentDescription("カテゴリを指定して支出を素早く記録します。金額は後で編集可能です。")
    
    @Parameter(title: "カテゴリ名")
    var categoryName: String
    
    init() {
        self.categoryName = ""
    }
    
    init(categoryName: String) {
        self.categoryName = categoryName
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let repository = AppContainer.shared.repository
        
        // カテゴリを検索
        let category = (try? repository.fetchAll())?.first(where: { $0.name == categoryName })
        
        // 0円のトランザクションを作成（後で編集することを想定）
        let transaction = Transaction(amount: 0, category: category)
        
        do {
            try repository.add(transaction)
            // ウィジェットを更新
            return .result()
        } catch {
            return .result()
        }
    }
}
