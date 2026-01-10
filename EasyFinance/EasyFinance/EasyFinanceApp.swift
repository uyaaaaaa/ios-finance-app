import SwiftData
import SwiftUI

@main
struct EasyFinanceApp: App {
    let container = DataController.shared.container

    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator)
                .modelContainer(container)
                .onAppear {
                    AppContainer.shared.dataSeedingService.seedDataIfNeeded()
                }
                .onOpenURL { url in
                    coordinator.handleDeepLink(url, repository: AppContainer.shared.repository)
                }
        }
    }
}
