//
//  TaskRepositoryProtocol.swift
//  TaskFlow-AsyncAwait
//
//  Created by Jyoti Purohit on 01/05/26.
//

import Foundation

protocol TaskRepositoryProtocol {
    func fetchTasks() async throws -> [TaskItem]
    func addTask(_ task: TaskItem) async throws
    func updateTask(_ task: TaskItem) async throws
    func deleteTask(id: UUID) async throws
}
