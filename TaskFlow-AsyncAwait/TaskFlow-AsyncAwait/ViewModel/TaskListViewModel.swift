//
//  TaskListViewModel.swift
//  TaskFlow-AsyncAwait
//
//  Created by Jyoti Purohit on 01/05/26.
//

import Foundation
internal import Combine

@MainActor
final class TaskListViewModel: ObservableObject {

    @Published var tasks: [TaskItem] = []
    @Published var filterStatus: TaskItem.TaskStatus? = nil
    @Published var searchText: String = ""
    @Published var errorMessage: String?

    // Computed property automatically updates when any @Published changes
    var filteredTasks: [TaskItem] {
        tasks
            .filter { task in
                (filterStatus == nil || task.status == filterStatus) &&
                (searchText.isEmpty || task.title.localizedCaseInsensitiveContains(searchText))
            }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private let repository: TaskRepositoryProtocol

    init(repository: TaskRepositoryProtocol = CoreDataTaskRepository()) {
        self.repository = repository
    }

    // MARK: - Async Actions

    func loadTasks() async {
        do {
            tasks = try await repository.fetchTasks()
        } catch {
            handle(error)
        }
    }

    func addTask(_ task: TaskItem) async {
        do {
            try await repository.addTask(task)
            await loadTasks()        // refresh list
        } catch {
            handle(error)
        }
    }

    func updateTask(_ task: TaskItem) async {
        do {
            try await repository.updateTask(task)
            await loadTasks()
        } catch {
            handle(error)
        }
    }

    func deleteTask(id: UUID) async {
        do {
            try await repository.deleteTask(id: id)
            await loadTasks()
        } catch {
            handle(error)
        }
    }

    // MARK: - Error Handling

    private func handle(_ error: Error) {
        errorMessage = error.localizedDescription
        _ = Swift.Task {
            try? await Swift.Task.sleep(for: .seconds(3))
            errorMessage = nil
        }
    }
}
