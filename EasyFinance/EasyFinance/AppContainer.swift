import Foundation
import SwiftData

// Simple Dependency Injection Container
@MainActor
class AppContainer {
    static let shared = AppContainer()

    let dataController: DataController

    // Abstracted Repository
    let repository: FinanceRepository

    // Services
    let dataSeedingService: DataSeedingServiceProtocol
    let errorHandlingService: ErrorHandlingServiceProtocol

    /// 本番環境用の初期化
    private init() {
        self.dataController = DataController.shared
        self.repository = SwiftDataFinanceRepository(context: dataController.context)
        self.errorHandlingService = ErrorHandlingService()
        self.dataSeedingService = DataSeedingService(repository: self.repository)
    }
    
    init(
        repository: FinanceRepository,
        errorHandlingService: ErrorHandlingServiceProtocol,
        dataSeedingService: DataSeedingServiceProtocol
    ) {
        self.dataController = DataController.shared
        self.repository = repository
        self.errorHandlingService = errorHandlingService
        self.dataSeedingService = dataSeedingService
    }
}
