//  Copyright © 2019 Apple Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import UIKit
import CoreData

// MARK: - Creating Contexts

let appTransactionAuthorName = "app"

/**
 A convenience method for creating background contexts that specify the app as their transaction author.
 */
extension NSPersistentContainer {
    func backgroundContext() -> NSManagedObjectContext {
        let context = newBackgroundContext()
        context.transactionAuthor = appTransactionAuthorName
        return context
    }
}

// MARK: - Saving Contexts

/**
 Contextual information for handling Core Data context save errors.
 */
enum ContextSaveContextualInfo: String {
//    case addPost = "adding a post"
//    case deletePost = "deleting a post"
//    case batchAddPosts = "adding a batch of post"
//    case deduplicate = "deduplicating tags"
//    case updatePost = "saving post details"
//    case addTag = "adding a tag"
//    case deleteTag = "deleting a tag"
//    case addAttachment = "adding an attachment"
//    case deleteAttachment = "deleting an attachment"
//    case saveFullImage = "saving a full image"
    case addTask = "adding a task"
    case addTaskRecord = "adding a task record"
    case deleteTask = "deleting a task"
    case deleteTaskRecord = "deleting a task record"
    case updateTask = "updating a task"
    case updateTaskRecord = "updating a task record"
}

extension NSManagedObjectContext {
    
    /**
     Handles save error by presenting an alert.
     */
    private func handleSavingError(_ error: Error, contextualInfo: ContextSaveContextualInfo) {
        print("Context saving error: \(error)")
        
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.delegate?.window,
                let viewController = window?.rootViewController else { return }
            
            let message = "Failed to save the context when \(contextualInfo.rawValue)."
            
            // Append message to existing alert if present
            if let currentAlert = viewController.presentedViewController as? UIAlertController {
                currentAlert.message = (currentAlert.message ?? "") + "\n\n\(message)"
                return
            }
            
            // Otherwise present a new alert
            let alert = UIAlertController(title: "Core Data Saving Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
    
    /**
     Save a context, or handle the save error (for example, when there data inconsistency or low memory).
     */
    func save(with contextualInfo: ContextSaveContextualInfo) {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            handleSavingError(error, contextualInfo: contextualInfo)
        }
    }
}
