//
//  StartWatchViewController.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/27/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import UIKit
import CoreData

class StartWatchViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var banner: UIView!
    @IBOutlet private weak var lblElapsedTime: UILabel!
    @IBOutlet private weak var lblTaskName: UILabel!
    @IBOutlet private weak var lblTaskEmoji: UILabel!
    @IBOutlet private var favorites: [UIView]!
    @IBOutlet var favoritesLabels: [UILabel]!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var btnStop: UIImageView!
    
    // MARK: - Properties
    let taskController = TaskController()
    lazy var notFavoriteTasksFetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest = self.taskController.notFavoriteTasksFetchRequest
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "order", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func updateViews() {
        guard self.isViewLoaded else { return }
        
        // clear favorites
        for taskSquare in favorites {
            taskSquare.backgroundColor = .systemGray
        }
        for taskSquareLabel in favoritesLabels {
            taskSquareLabel.text = ""
        }
        
        // fill favorites
        for task in taskController.favoriteTasks {
            let taskSquare = favorites.first { $0.tag == task.order }
            let taskSquareLabel = favoritesLabels.first { $0.tag == task.order }
            taskSquare?.backgroundColor = UIColor.taskColor(TaskColor(rawValue: task.color) ?? TaskColor.white)
            taskSquareLabel?.text = task.emoji
        }
    }
    
    // MARK: - Actions
    @IBAction func bannerTapped(_ sender: Any) {
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
    }
    
    @IBAction func plusTapped(_ sender: Any) {
    }
    
    @IBAction func editTapped(_ sender: Any) {
    }
    
    @IBAction func stopTapped(_ sender: Any) {
    }
    
    @IBAction func backArrowTapped(_ sender: Any) {
    }
    
    @IBAction func quickTapped(_ sender: Any) {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension StartWatchViewController: UITableViewDelegate {
    
}

extension StartWatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension StartWatchViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // newIndexPath is option bc you'll only get it for insert and move
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}
