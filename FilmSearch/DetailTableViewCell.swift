//
//  DetailTableViewCell.swift
//  Master-Detail
//
//  Created by Denys on 9/1/16.
//  Copyright © 2016 Denys Holub. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
  
  @IBOutlet weak var keyLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
