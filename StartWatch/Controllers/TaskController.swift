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

class TaskController {
    
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
    
    // TODO
    func checkAvailability(color: TaskColor, emoji: String) -> Bool {
        // checks to see if this color + emoji combination has already been used
        
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
