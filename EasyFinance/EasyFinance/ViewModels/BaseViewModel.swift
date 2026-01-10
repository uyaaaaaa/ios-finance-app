import Combine
import Foundation
import SwiftUI

// Base ViewModel
@MainActor
class BaseViewModel: ObservableObject {
    let repository: FinanceRepository
    let errorHandler: ErrorHandlingServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(repository: FinanceRepository, errorHandler: ErrorHandlingServiceProtocol) {
        self.repository = repository
        self.errorHandler = errorHandler
        setupDataObserver()
    }
    
    // Setup data observer
    private func setupDataObserver() {
        repository.dataChanged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.handleDataChanged()
            }
            .store(in: &cancellables)
    }
    
    // Handle data changed
    func handleDataChanged() {
        // Implement in subclass
    }
    
    // Handle error
    func handleError(_ error: Error, context: String) {
        errorHandler.handle(error, context: context)
    }
}
