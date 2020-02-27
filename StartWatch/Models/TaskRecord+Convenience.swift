//
//  TaskRecord+Convenience.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation
import CoreData

extension TaskRecord {
    convenience init(startTime: Date?, endTime: Date?, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = UUID()
        if let startTime = startTime {
            self.startTime = startTime
        } else {
            self.startTime = Date()
        }
        if let endTime = endTime {
            self.endTime = endTime
        } else {
            self.endTime = Date()
        }
    }
}
