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
    private(set) var runningTasksFetchRequest: NSFetchRequest<TaskRecord>
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
        
        runningTasksFetchRequest = TaskRecord.fetchRequest()
        var predicate = NSPredicate(format: "endTime = $DATE")
        predicate = predicate.withSubstitutionVariables(["DATE" : NSNull()])
        runningTasksFetchRequest.predicate = predicate
        runningTasksFetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        
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
            // There should never be more than one running task
            // If there are, we need to end the extras
            
            let allTaskRecordsAfterDateFetchRequest: NSFetchRequest<TaskRecord> = TaskRecord.fetchRequest()
            allTaskRecordsAfterDateFetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "startTime", ascending: true)
            ]
            
            for running in runningTaskRecords {
                var allTaskRecordsAfterDate: [TaskRecord] = []
                guard let startTime = running.startTime else { continue }
                
                // find task records that begin after this running task record
                let predicate = NSPredicate(format: "startTime > %@", startTime as NSDate)
                allTaskRecordsAfterDateFetchRequest.predicate = predicate
                do {
                    allTaskRecordsAfterDate = try CoreDataStack.shared.mainContext.fetch(allTaskRecordsAfterDateFetchRequest)
                } catch {
                    print("Unable to search for task records occurring after running task: \(error)")
                    continue
                }
                
                // apply the start time of the next record to the end time of the running record
                if allTaskRecordsAfterDate.count >= 1 {
                    running.endTime = allTaskRecordsAfterDate[0].startTime
                }
            }
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("Unable to save after ending tasks: \(error)")
            }
            
            if runningTaskRecords.last?.endTime == nil {
                return runningTaskRecords.last?.task
            } else {
                return nil
            }
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
        
        let availableFetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate = NSPredicate(format: "color == %f && emoji == %@", color.rawValue, emoji)
        availableFetchRequest.predicate = predicate
        
        var hits: [Task] = []
        do {
            hits = try CoreDataStack.shared.mainContext.fetch(availableFetchRequest)
        } catch {
            print("Couldn't fetch tasks to check availability: \(error)")
        }
        
        if hits.count > 0 {
            return false
        } else {
            return true
        }
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
