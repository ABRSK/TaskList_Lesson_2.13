//
//  StorageManager.swift
//  TaskList_Lesson_2.13
//
//  Created by Андрей Барсук on 31.05.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList_Lesson_2_13")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasks() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data.", error)
        }
        
        return taskList
    }
    
    func saveTask(with taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? Task else { return }
        task.title = taskName
    }
    
    func editTask(with taskName: String, for index: Int) {
        let taskList = fetchTasks()
        let task = taskList[index]
        task.title = taskName
    }
    
    func deleteTask(for index: Int) {
        let taskList = fetchTasks()
        let task = taskList[index]
        persistentContainer.viewContext.delete(task)
    }
}
