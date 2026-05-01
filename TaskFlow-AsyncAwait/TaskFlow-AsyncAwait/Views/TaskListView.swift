//
//  TaskListView.swift
//  TaskFlow-AsyncAwait
//
//  Created by Jyoti Purohit on 01/05/26.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Filter", selection: $viewModel.filterStatus) {
                    Text("All").tag(TaskItem.TaskStatus?.none)
                    ForEach(TaskItem.TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(TaskItem.TaskStatus?.some(status))
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if viewModel.filteredTasks.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
                } else {
                    List {
                        ForEach(viewModel.filteredTasks) { task in
                            TaskRowView(task: task)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        Swift.Task { await viewModel.deleteTask(id: task.id) }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    let next: TaskItem.TaskStatus = switch task.status {
                                    case .todo: .inProgress
                                    case .inProgress: .done
                                    case .done: .todo
                                    }
                                    var updated = task
                                    updated.status = next
                                    Task { await viewModel.updateTask(updated) }
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("TaskFlow")
            .searchable(text: $viewModel.searchText, prompt: "Search tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditTaskView { newTask in
                    Task { await viewModel.addTask(newTask) }
                }
            }
            .overlay(alignment: .top) {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .background(.red.opacity(0.9), in: Capsule())
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(), value: viewModel.errorMessage != nil)
                }
            }
        }
        .task {
            await viewModel.loadTasks()
        }
    }
}
