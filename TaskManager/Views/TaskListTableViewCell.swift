//
//  TaskListTableViewCell.swift
//  TaskManager
//
//  Created by Alireza Asadi on 3/4/1398 AP.
//  Copyright © 1398 AP MrAlirezaa. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func toggleCheck() {
        if checkButton.currentImage == UIImage(named: "circle") {
            checkButton.setImage(UIImage(named: "check-circle"), for: .normal)
            self.contentView.backgroundColor = .red
        } else {
            checkButton.setImage(UIImage(named: "circle"), for: .normal)
            self.contentView.backgroundColor = TMColors.lightBlue
        }
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {
        toggleCheck()

    }
}
