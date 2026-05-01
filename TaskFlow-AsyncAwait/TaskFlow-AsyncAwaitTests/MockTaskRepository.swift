//
//  MockTaskRepository.swift
//  TaskFlow-AsyncAwaitTests
//
//  Created by Chetan Purohit on 01/05/26.
//

@testable import TaskFlow_AsyncAwait
import Foundation

final class MockTaskRepository: TaskRepositoryProtocol {
    var storedTasks: [TaskItem] = []
    var shouldThrow = false
    var error: Error = RepositoryError.taskNotFound

    func fetchTasks() async throws -> [TaskItem] {
        if shouldThrow { throw error }
        return storedTasks
    }

    func addTask(_ task: TaskItem) async throws {
        if shouldThrow { throw error }
        storedTasks.append(task)
    }

    func updateTask(_ task: TaskItem) async throws {
        if shouldThrow { throw error }
        guard let index = storedTasks.firstIndex(where: { $0.id == task.id }) else {
            throw RepositoryError.taskNotFound
        }
        storedTasks[index] = task
    }

    func deleteTask(id: UUID) async throws {
        if shouldThrow { throw error }
        storedTasks.removeAll { $0.id == id }
    }
}
