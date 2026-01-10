import SwiftData
import SwiftUI

@MainActor
class DataController {
    static let shared = DataController()
    
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                Transaction.self,
                Category.self,
                Budget.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var context: ModelContext {
        container.mainContext
    }
    
    // Preview helper
    static var previewContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
            Category.self,
            Budget.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create preview container: \(error)")
        }
    }()
}
