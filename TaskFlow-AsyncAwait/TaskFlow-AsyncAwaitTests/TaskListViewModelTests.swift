//
//  TaskListViewModelTests.swift
//  TaskFlow-AsyncAwaitTests
//
//  Created by Chetan Purohit on 01/05/26.
//

import XCTest
@testable import TaskFlow_AsyncAwait

@MainActor
final class TaskListViewModelTests: XCTestCase {

    var mockRepository: MockTaskRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockTaskRepository()
    }

    func test_initialState_tasksEmpty() async {
        let vm = TaskListViewModel(repository: mockRepository)
        await vm.loadTasks()
        XCTAssertTrue(vm.tasks.isEmpty)
        XCTAssertTrue(vm.filteredTasks.isEmpty)
    }

    func test_filtering_showsOnlyInProgress() async {
        mockRepository.storedTasks = [
            TaskItem(id: UUID(), title: "A", priority: .normal, status: .todo, createdAt: Date()),
            TaskItem(id: UUID(), title: "B", priority: .normal, status: .inProgress, createdAt: Date())
        ]
        let vm = TaskListViewModel(repository: mockRepository)
        await vm.loadTasks()
        vm.filterStatus = .inProgress
        XCTAssertEqual(vm.filteredTasks.count, 1)
        XCTAssertEqual(vm.filteredTasks.first?.status, .inProgress)
    }

    func test_searchFiltersByTitle() async {
        mockRepository.storedTasks = [
            TaskItem(id: UUID(), title: "Buy groceries", priority: .normal, status: .todo, createdAt: Date()),
            TaskItem(id: UUID(), title: "Call dentist", priority: .normal, status: .todo, createdAt: Date())
        ]
        let vm = TaskListViewModel(repository: mockRepository)
        await vm.loadTasks()
        vm.searchText = "dentist"
        XCTAssertEqual(vm.filteredTasks.count, 1)
        XCTAssertTrue(vm.filteredTasks.first?.title.contains("dentist") ?? false)
    }

    func test_addTaskUpdatesList() async {
        let vm = TaskListViewModel(repository: mockRepository)
        let newTask = TaskItem(id: UUID(), title: "New", priority: .normal, status: .todo, createdAt: Date())
        await vm.addTask(newTask)
        XCTAssertEqual(vm.tasks.count, 1)
        XCTAssertEqual(vm.tasks.first?.title, "New")
    }

    func test_deleteTaskRemovesItem() async {
        let task = TaskItem(id: UUID(), title: "Temp", priority: .normal, status: .todo, createdAt: Date())
        mockRepository.storedTasks = [task]
        let vm = TaskListViewModel(repository: mockRepository)
        await vm.loadTasks()
        await vm.deleteTask(id: task.id)
        XCTAssertTrue(vm.tasks.isEmpty)
    }

    func test_errorPropagationShowsErrorMessage() async {
        mockRepository.shouldThrow = true
        mockRepository.error = RepositoryError.taskNotFound
        let vm = TaskListViewModel(repository: mockRepository)
        await vm.loadTasks()
        XCTAssertNotNil(vm.errorMessage)
    }
}
