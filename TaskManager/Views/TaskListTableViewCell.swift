//
//  TaskListTableViewCell.swift
//  TaskManager
//
//  Created by Alireza Asadi on 3/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

protocol TaskListTableViewCellDelegate {
    func toggledDoneStatus(_ cell: TaskListTableViewCell, task: TMTask)
}

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    var task: TMTask!

    var delegate: TaskListTableViewCellDelegate?

    private func toggleCheck() {
        task.doneStatus = task.doneStatus! ? false : true
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundView = UIView()
        self.backgroundColor = .clear

        if task.doneStatus! {
            checkButton.setImage(UIImage(named: "check-circle"), for: .normal)
            self.contentView.backgroundColor = TMColors.lightBlue.withAlphaComponent(0.7)
            taskTitleLabel.alpha = 0.5
            checkButton.alpha = 0.5

        } else {
            checkButton.setImage(UIImage(named: "circle"), for: .normal)
            self.contentView.backgroundColor = TMColors.lightBlue.withAlphaComponent(0.9)
            taskTitleLabel.alpha = 1
            checkButton.alpha = 1
        }
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {
        toggleCheck()
        delegate?.toggledDoneStatus(self, task: task)
    }
}
