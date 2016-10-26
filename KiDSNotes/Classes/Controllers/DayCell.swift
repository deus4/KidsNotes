//
//  DayCell.swift
//  CalendarTest
//
//  Created by deus4 on 07/10/16.
//  Copyright © 2016 Deus4. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    @IBOutlet weak var todayDateView: UIView! {
        didSet {
            todayDateView.layer.borderWidth = 2
            todayDateView.layer.borderColor = UIColor.blue.cgColor
            todayDateView.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var selectedView: UIView!{
        didSet{
            selectedView.layer.cornerRadius = 15.0
        }
    }
    
}
