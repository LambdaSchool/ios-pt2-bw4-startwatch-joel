//
//  Task+CoreDataProperties.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/26/20.
//  Copyright © 2020 Julltron. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var color: Int16
    @NSManaged public var emoji: String?
    @NSManaged public var favorite: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var running: Bool
    @NSManaged public var taskRecords: NSSet?

    public var taskRecordsArray: [TaskRecord] {
        let set = taskRecords as? Set<TaskRecord> ?? []
        
        return set.sorted {
            guard let date0 = $0.startTime, let date1 = $1.startTime else {
                return false
            }
            return  date0 < date1
        }
    }
}

// MARK: Generated accessors for taskRecords
extension Task {

    @objc(addTaskRecordsObject:)
    @NSManaged public func addToTaskRecords(_ value: TaskRecord)

    @objc(removeTaskRecordsObject:)
    @NSManaged public func removeFromTaskRecords(_ value: TaskRecord)

    @objc(addTaskRecords:)
    @NSManaged public func addToTaskRecords(_ values: NSSet)

    @objc(removeTaskRecords:)
    @NSManaged public func removeFromTaskRecords(_ values: NSSet)

}
