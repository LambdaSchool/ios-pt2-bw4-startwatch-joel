//
//  TaskDetailViewController.swift
//  StartWatch
//
//  Created by Joel Groomer on 2/27/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet private weak var btnSave: UIBarButtonItem!
    @IBOutlet private weak var taskColor: UIView!
    @IBOutlet private weak var lblTaskEmoji: UILabel!
    @IBOutlet private weak var txtTaskName: UITextField!
    @IBOutlet private weak var txtOptionalIdentifier: UITextField!
    @IBOutlet private weak var txtvTaskNotes: UITextView!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
//    var taskController
    var task: Task?
    
    
    // MARK: Views
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any) {
    }
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    

}
