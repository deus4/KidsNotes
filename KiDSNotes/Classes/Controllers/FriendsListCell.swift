//
//  FriendsListCell.swift
//  KiDSNotes
//
//  Created by deus4 on 14/10/16.
//  Copyright © 2016 deus4. All rights reserved.
//

import UIKit

class FriendsListCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
