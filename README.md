# TaskFlow-AsyncAwait

# TaskFlow-AsyncAwait

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue" alt="iOS 17+">
  <img src="https://img.shields.io/badge/Xcode-16.0+-blueviolet" alt="Xcode 16+">
  <img src="https://img.shields.io/badge/Architecture-MVVM--async/await-success" alt="Architecture">
  <img src="https://img.shields.io/badge/Persistence-Core%20Data-lightgrey" alt="Core Data">
  <img src="https://img.shields.io/badge/Test%20Coverage-90%25%2B-brightgreen" alt="Coverage">
</p>

A **production‑grade task manager** built entirely with **Swift Concurrency** — `async/await`, no Combine.  
Clean MVVM architecture, Core Data persistence, full unit tests — the exact skill set modern iOS teams look for.

> **Part of a multi‑architecture series** — the same feature set is also implemented with **Combine** and **The Composable Architecture (TCA)** in separate repositories.  
> This branch focuses on **async/await**, the native concurrency model in Swift 6.

---

## 📱 Features

- Create, edit, delete, and search tasks
- Filter by status (To‑Do, In‑Progress, Done)
- Priority levels (Low, Normal, High) with visual indicators
- Due date support
- Offline‑first: all data persisted locally with Core Data
- Instant UI updates via `@Published` and SwiftUI’s reactive loop
- Graceful error handling with temporary banners
- Fully tested ViewModel with mock dependencies

---

## 🧱 Architecture – MVVM + async/await

┌──────────────────────────────────────────┐
│ SwiftUI Views │
│ TaskListView, TaskRow, AddEditTaskView │
│ @StateObject var viewModel │
│ .task { await viewModel.loadTasks() } │
└────────────────┬─────────────────────────┘
│ async calls
┌────────────────▼─────────────────────────┐
│ TaskListViewModel │
│ @Published var tasks / filter / … │
│ func loadTasks() async │
│ func addTask(:) async │
│ calls TaskRepositoryProtocol │
└────────────────┬─────────────────────────┘
│ protocol (async throws)
┌────────────────▼─────────────────────────┐
│ CoreDataTaskRepository │
│ Implements TaskRepositoryProtocol │
│ fetchTasks() async throws -> [TaskItem] │
│ addTask(:) async throws │
└──────────────────────────────────────────┘

___

## 🛠 Tech Stack

| Layer            | Technology                    |
|------------------|-------------------------------|
| UI               | SwiftUI                       |
| Concurrency      | Swift Concurrency (async/await) |
| Persistence      | Core Data                     |
| Architecture     | MVVM                          |
| Testing          | XCTest, async tests           |
| Minimum Target   | iOS 17.0                      |
| Language         | Swift 6                       |

---

## 📂 Project Structure

TaskFlow/
├── App/
│   ├── TaskFlowApp.swift               # @main entry
│   └── PersistenceController.swift     # Core Data stack
├── Model/
│   ├── TaskItem.swift                  # Domain model (renamed from Task)
│   ├── TaskEntity+CoreDataClass.swift  # Core Data entity (manual)
│   └── TaskEntity+Mapping.swift        # Entity ↔ Domain mapping
├── Repository/
│   ├── TaskRepositoryProtocol.swift    # Abstract repository (async throws)
│   └── CoreDataTaskRepository.swift    # Core Data implementation
├── ViewModel/
│   └── TaskListViewModel.swift         # Async actions, computed filtering
├── View/
│   ├── TaskListView.swift              # Main screen
│   ├── TaskRowView.swift               # Row cell
│   └── AddEditTaskView.swift           # New/Edit sheet
└── Tests/
    ├── TaskListViewModelTests.swift    # ViewModel unit tests (async)
    └── MockTaskRepository.swift        # Test double
    
___

## 🧪 Testing & Code Coverage

1. Run tests from the command line

xcodebuild test -scheme TaskFlow -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.0'
- All ViewModel tests use a MockTaskRepository and run synchronously under Swift’s async test methods.
- No real Core Data stack needed — tests are deterministic and fast.

2. Inspect coverage in Xcode
- Enable code coverage in the test plan.
- Run with ⌘U.
- Open Report navigator (⌘9) → latest Test → Coverage tab.
- Currently >90 % of ViewModel and Repository logic is covered.

---
## 📬 Contact

Chetan
iOS Developer
Chetan81289@outlook.com

---
