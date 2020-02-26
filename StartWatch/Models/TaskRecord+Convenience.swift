//
//  TaskRecord+Convenience.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation

extension TaskRecord {
    convenience init(taskID: UUID, startTime: Date?, endTime: Date?) {
        self.init()
        
        self.id = UUID()
        self.taskID = taskID
        if let startTime = startTime {
            self.startTime = startTime
        } else {
            startTime = Date()
        }
        if let endTime = endTime {
            endTime = endTime
        } else {
            endTime = Date()
        }
    }
}
