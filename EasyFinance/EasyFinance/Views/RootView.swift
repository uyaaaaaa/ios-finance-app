import SwiftUI

struct RootView: View {
    @Bindable var coordinator: AppCoordinator

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $coordinator.selectedTab) {
                DashboardView()
                    .tag(0)

                HistoryView()
                    .tag(1)
            }

            // Custom Tab Bar
            customTabBar
        }
        .sheet(isPresented: $coordinator.isInputViewPresented) {
            InputView()
        }
    }

    private var customTabBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(alignment: .center, spacing: 0) {
                // Home Button
                Button {
                    coordinator.selectedTab = 0
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.title2)
                        Text("ホーム")
                            .font(.caption2)
                    }
                    .foregroundColor(coordinator.selectedTab == 0 ? .accentColor : .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Center Plus Button (Floating)
                Button {
                    coordinator.isInputViewPresented = true
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(.accentColor)
                            .frame(width: 66, height: 66)
                            .shadow(
                                color: .accentColor.opacity(0.3), radius: 8, x: 0, y: 4)

                        Image(systemName: "plus")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .offset(y: -4)
                .frame(maxWidth: .infinity)

                // History Button
                Button {
                    coordinator.selectedTab = 1
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                            .font(.title2)
                        Text("履歴")
                            .font(.caption2)
                    }
                    .foregroundColor(coordinator.selectedTab == 1 ? .accentColor : .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(height: 60) // バーの高さを60に固定
            .padding(.horizontal)
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
        }
    }
}
