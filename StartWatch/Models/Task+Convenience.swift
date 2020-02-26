//
//  Task+Convenience.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    convenience init(name: String, color: TaskColor, emoji: String, context: NSManagedObjectContext) {
        self.init()
        self.id = UUID()
        self.name = name
        self.color = color.rawValue
        self.emoji = emoji.isSingleEmoji ? emoji : "❓"
        self.running = false
        self.favorite = TaskFavorite.no.rawValue
    }
}
