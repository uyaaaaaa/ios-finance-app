import Foundation

// Error Handling Service Protocol
protocol ErrorHandlingServiceProtocol {
    func handle(_ error: Error, context: String)
}

// Error Handling Service
class ErrorHandlingService: ErrorHandlingServiceProtocol {
    func handle(_ error: Error, context: String) {
        print("\(context): \(error.localizedDescription)")
    }
}
