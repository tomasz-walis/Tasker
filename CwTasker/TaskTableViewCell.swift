//
//  TaskTableViewCell.swift
//  CwTasker
//
//  Created by Tomasz Walis-Walisiak on 06/05/2018.
//  Copyright © 2018 Tomasz Walis-Walisiak. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {


    @IBOutlet weak var labelTaskName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
