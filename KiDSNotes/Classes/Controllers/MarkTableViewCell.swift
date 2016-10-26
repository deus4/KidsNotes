//
//  MarkTableViewCell.swift
//  CalendarTest
//
//  Created by deus4 on 11/10/16.
//  Copyright © 2016 Deus4. All rights reserved.
//

import UIKit

class MarkTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var markDescriptionLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
