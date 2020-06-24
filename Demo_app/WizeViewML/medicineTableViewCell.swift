//
//  medicineTableViewCell.swift
//  Demo_app
//
//  Created by Daksh Parikh on 8/5/19.
//  Copyright © 2019 Daksh Parikh. All rights reserved.
//

import UIKit

class medicineTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_1: UILabel!
    
    @IBOutlet weak var lbl_2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
