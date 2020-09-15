//
//  CustomCell.swift
//  CwTasker
//
//  Created by Tomasz Walis-Walisiak on 05/05/2018.
//  Copyright © 2018 Tomasz Walis-Walisiak. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var lbCwName: UILabel!
    @IBOutlet weak var lbWeight: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLevel: UILabel!
    @IBOutlet weak var lbDueDate: UILabel!
    @IBOutlet weak var lbDaysLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
