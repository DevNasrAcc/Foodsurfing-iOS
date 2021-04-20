//
//  MenuCell.swift
//  Foodsurfing
//
//  Created by developer on 21/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var imageName: String = ""
    
    override var isSelected: Bool {
        didSet {
            lineView.isHidden = !isSelected
            if isSelected {
                self.imgIcon.image = UIImage(named: self.imageName.replacingOccurrences(of: "default", with: "highlight"))
                lblTitle.textColor = Helper.hexStringToUIColor(hex: "D61A6A")
            }
            else {
                self.imgIcon.image = UIImage(named: self.imageName.replacingOccurrences(of: "highlight", with: "default"))
                lblTitle.textColor = UIColor.black
            }
        }
    }
    
}
