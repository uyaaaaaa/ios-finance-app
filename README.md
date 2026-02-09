# EasyFinance

An iOS application meticulously designed to lower the barrier to personal finance management, making it effortless to track expenses and stay on budget.

## Core Concept

**"The World's Lowest First Step in Personal Finance."**

The core philosophy of EasyFinance is to minimize the friction of logging expenses. Traditional budgeting apps often fail because the simple act of opening the app, navigating to the input screen, and entering data becomes a chore. This app eliminates those steps by deeply integrating with the iOS ecosystem.

## Key Features

- **⚡️ Ultra-Fast Input:** Log expenses in literally two taps without even opening the app.
  - **Widgets:** Add expenses directly from your Home Screen or Lock Screen.
  - **App Shortcuts:** Use Siri or Shortcuts to record transactions on the fly.
- **📊 At-a-Glance Budget Tracking:** The main app screen is dedicated to one thing: showing you how much you have left to spend this month. A simple, visual indicator tells you immediately if you are on track or overspending.
- **📖 Simple History:** Quickly review, edit, or delete your recent transactions. No complex charts or overwhelming analytics.

## Tech Stack

- **UI Framework:** SwiftUI
- **Data Persistence:** SwiftData
- **Core Logic:** Swift
- **External Integration:** App Intents Framework (for Widgets and Shortcuts)

## Architecture

This project follows a modern SwiftUI architecture, emphasizing a clear separation of concerns.

- **`Views`**: SwiftUI views responsible for the UI.
- **`ViewModels`**: Manages the state and business logic for the views (MVVM).
- **`Models`**: Data structures representing transactions, budgets, etc. (`Codable`, identifiable objects).
- **`Domain`**: Contains core business logic, such as calculators and strategies, independent of other layers.
- **`Infrastructure`**: Concrete implementations of repository interfaces, currently using `SwiftDataFinanceRepository`.
- **`Intents`**: Handles the logic for App Intents, enabling Widgets and Shortcuts functionality.
- **`Coordinator`**: Manages navigation and dependency injection throughout the app.

```
.
└───EasyFinance/
    ├───EasyFinanceApp.swift        // Application entry point
    ├───AppContainer.swift          // Dependency injection / Composition Root
    ├───Coordinator/                // Manages navigation and DI
    ├───Controllers/                // Data-related control logic
    ├───Domain/                     // Core business logic and interfaces
    │   └───Interfaces/
    ├───Infrastructure/             // Concrete implementations (e.g., persistence)
    │   └───SwiftData/
    ├───Intents/                    // App Intent handling for Widgets/Shortcuts
    ├───Models/                     // Data structures
    ├───Services/                   // Application-wide services (e.g., error handling, data seeding)
    ├───Utilities/                  // General utility extensions and helpers
    ├───ViewModels/                 // Manages view state and business logic
    │   └───Components/             // ViewModels for reusable UI components
    └───Views/                      // SwiftUI views for UI presentation
        └───Components/             // Reusable SwiftUI components
```

## Getting Started

1.  Clone this repository.
2.  Open `EasyFinance.xcodeproj` in Xcode.
3.  Select a simulator or a physical device.
4.  Build and run the project (Cmd+R).

