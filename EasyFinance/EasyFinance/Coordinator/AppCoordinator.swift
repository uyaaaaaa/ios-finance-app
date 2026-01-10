import Observation
import SwiftUI

@Observable
class AppCoordinator {
    var selectedTab: Int = 0
    var isInputViewPresented: Bool = false

    // Dependencies can be injected if needed, but for simple state management logic:

    func handleDeepLink(_ url: URL, repository: FinanceRepository) {
        // Expected format: myapp://input?category=Food
        guard url.scheme == "myapp", url.host == "input" else { return }

        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let categoryName = components.queryItems?.first(where: { $0.name == "category" })?.value
        {

            // Try to find category
            if (try? repository.find(byName: categoryName)) != nil {
                // Pass this to InputView (InputView needs to accept a param)
                // For MVP, we'll just open InputView.
                print("Deep link category: \(categoryName)")
            }
        }

        // Switch to Dashboard tab and open sheet
        selectedTab = 0
        isInputViewPresented = true
    }
}
