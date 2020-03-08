//
//  TaskTableViewCell.swift
//  StartWatch
//
//  Created by Joel Groomer on 3/8/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskColorView: UIView!
    @IBOutlet weak var lblTaskEmoji: UILabel!
    @IBOutlet weak var lblTaskName: UILabel!
    
    var task: Task? { didSet { updateViews() } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func updateViews() {
        guard let task = task else { return }
        taskColorView.backgroundColor = UIColor.taskColor(TaskColor(rawValue: task.color) ?? TaskColor.white)
        lblTaskEmoji.text = task.emoji
        lblTaskName.text = task.name
    }
}
