//
//  TaskFlow_AsyncAwaitApp.swift
//  TaskFlow-AsyncAwait
//
//  Created by Chetan Purohit on 01/05/26.
//

import SwiftUI

@main
struct TaskFlowApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
