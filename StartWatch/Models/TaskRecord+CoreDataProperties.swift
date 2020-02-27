//
//  TaskRecord+CoreDataProperties.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/26/20.
//  Copyright © 2020 Julltron. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskRecord> {
        return NSFetchRequest<TaskRecord>(entityName: "TaskRecord")
    }

    @NSManaged public var endTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var startTime: Date?
    @NSManaged public var task: Task?

}
