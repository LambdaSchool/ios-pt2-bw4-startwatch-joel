//
//  TaskController.swift
//  StartWatch
//
//  Created by Joel Groomer on 3/6/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum FetchRequestTemplates: String {
    case AllTasksFetchRequest
    case FavoriteTasksFetchRequest
    case NotFavoriteTasksFetchRequest
//    case RunningTasksFetchRequest
}

class TaskController {
    
    private(set) var taskFetchRequest: NSFetchRequest<Task>
    private(set) var favoriteTasksFetchRequest: NSFetchRequest<Task>
    private(set) var notFavoriteTasksFetchRequest: NSFetchRequest<Task>
    private(set) var runningTasksFetchRequest: NSFetchRequest<TaskRecord> = TaskRecord.fetchRequest()
    private(set) var tasks: [Task] = []
    private(set) var favoriteTasks: [Task] = []
    private(set) var notFavoriteTasks: [Task] = []
    private(set) var runningTaskRecords: [TaskRecord] = []
    
    init() {
        guard let model = CoreDataStack.shared.mainContext.persistentStoreCoordinator?.managedObjectModel,
            let fetchRequest = model.fetchRequestTemplate(forName: FetchRequestTemplates.AllTasksFetchRequest.rawValue) as? NSFetchRequest<Task>,
            let fetchRequestFavorites = model.fetchRequestTemplate(forName: FetchRequestTemplates.FavoriteTasksFetchRequest.rawValue) as? NSFetchRequest<Task>,
            let fetchRequestNotFavorites = model.fetchRequestTemplate(forName: FetchRequestTemplates.NotFavoriteTasksFetchRequest.rawValue) as? NSFetchRequest<Task>
            else { fatalError("Could not initialize fetch request") }
        taskFetchRequest = fetchRequest
        favoriteTasksFetchRequest = fetchRequestFavorites
        notFavoriteTasksFetchRequest = fetchRequestNotFavorites
        
        var predicate = NSPredicate(format: "date = $DATE")
        predicate = predicate.withSubstitutionVariables(["DATE" : NSNull()])
        runningTasksFetchRequest.predicate = predicate
        
        fetchTasks()
    }
    
    func fetchTasks() {
        do {
            tasks = try CoreDataStack.shared.mainContext.fetch(taskFetchRequest)
            favoriteTasks = try CoreDataStack.shared.mainContext.fetch(favoriteTasksFetchRequest)
            notFavoriteTasks = try CoreDataStack.shared.mainContext.fetch(notFavoriteTasksFetchRequest)
        } catch let error as NSError {
            print("Could not fetch tasks: \(error), \(error.userInfo)")
        }
    }
    
    @discardableResult func getRunningTask() -> Task? {
        do {
            runningTaskRecords = try CoreDataStack.shared.mainContext.fetch(runningTasksFetchRequest)
        } catch {
            print("Could not fetch running tasks: \(error)")
        }
        
        if runningTaskRecords.count == 0 {
            return nil
        } else if runningTaskRecords.count > 1 {
            // TODO: Handle multiple running tasks
            // should end older tasks with newer start time
            return nil  // should return the latest started task
        }
        
        return runningTaskRecords[0].task
    }
    
    func getRunningTimeInMinutes() -> Int {
        getRunningTask()    // make sure the running tasks are updated
        guard let startTime = runningTaskRecords[0].startTime else { return 0 }
        let taskDuration = Date().timeIntervalSince(startTime)
        return Int(taskDuration / 60)
    }
    
    // MARK: - Tasks
    
    func createTask(name: String,
                    emoji: String,
                    color: TaskColor,
                    order: Int16 = UNORDERED,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let task = Task(name: name, color: color, emoji: emoji, context: context)
        if order != UNORDERED {
            task.order = order
        }
        
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save new entry: \(error)")
                context.reset()
            }
        }
    }
    
    func updateTask(task: Task,
                    newName: String?,
                    newEmoji: String?,
                    newColor: TaskColor?,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        if let newName = newName {
            task.name = newName
        }
        
        if let newEmoji = newEmoji {
            task.emoji = newEmoji
        }
        
        if let newColor = newColor {
            task.color = newColor.rawValue
        }
        
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after updating: \(error)")
                context.reset()
            }
        }
    }
    
    func deleteTask(task: Task,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                    completion: @escaping (Error?) -> Void = { _ in }) {
        context.perform {
            do {
                context.delete(task)
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after deleting: \(error)")
                context.reset()
                completion(error)
            }
            completion(nil)
        }
    }
    
    func checkAvailability(color: TaskColor, emoji: String) -> Bool {
        // checks to see if this color + emoji combination has already been used
        
        // TODO: Implement checkAvailability
        
        return true
    }
    
    
    // MARK: - TaskRecords
    
    func addNewTaskRecord(to task: Task,
                          startTime: Date = Date(),
                          endTime: Date?,
                          context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                          completion: @escaping (Error?) -> Void = { _ in }) {
        let record = TaskRecord(startTime: startTime, endTime: endTime, context: context)
        record.task = task
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            print("Could not save after updating: \(error)")
            context.reset()
        }
    }
    
    func modifyTaskRecord(record: TaskRecord,
                          newStartTime: Date?,
                          newEndTime: Date?,
                          context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                          completion: @escaping (Error?) -> Void = { _ in }) {
        if let newStartTime = newStartTime {
            record.startTime = newStartTime
        }
        
        if let newEndTime = newEndTime {
            record.endTime = newEndTime
        }
        
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after updating record: \(error)")
                context.reset()
            }
        }
    }
    
    func moveTaskRecord(record: TaskRecord,
                        newTask: Task,
                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                        completion: @escaping (Error?) -> Void = { _ in }) {
        record.task = newTask
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after updating: \(error)")
                context.reset()
            }
        }
    }
    
    func deleteTaskRecord(record: TaskRecord,
                          context: NSManagedObjectContext = CoreDataStack.shared.mainContext,
                          completion: @escaping (Error?) -> Void = { _ in }) {
        context.perform {
            do {
                context.delete(record)
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Could not save after deleting record: \(error)")
                context.reset()
                completion(error)
            }
            completion(nil)
        }
    }
    
    func stopRunningTasks() {
        // TODO: Find all tasks with nil endDate and set endDate to now
    }
    
    // MARK: - Quick Tasks
    
    func newQuickTask(context: NSManagedObjectContext = CoreDataStack.shared.mainContext, completion: @escaping (Task?, TaskRecord?, Error?) -> Void) {
        let quickEmojis = ["🚀", "🏎", "🚅", "🐆", "🐰", "🐇", "⚡️", "☄️"]
        var colorInteger: Int16
        var quickEmojiIndex: Int
        repeat {
            colorInteger = Int16.random(in: TASK_COLOR_MIN...TASK_COLOR_MAX)
            quickEmojiIndex = Int.random(in: 0..<quickEmojis.count)
        } while checkAvailability(color: TaskColor(rawValue: colorInteger) ?? TaskColor.yellow, emoji: quickEmojis[quickEmojiIndex]) == false
        
        let time = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM dd, HH:mm")
        
        let task = Task(name: "Quick Task \(dateFormatter.string(from: time))", color: TaskColor(rawValue: colorInteger)!, emoji: quickEmojis[quickEmojiIndex], context: context)
        stopRunningTasks()
        let record = TaskRecord(startTime: time, endTime: nil, context: context)
        record.task = task
        
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save Quick Task: \(error)")
                completion(nil, nil, error)
            }
            completion(task, record, nil)
        }
    }
}
