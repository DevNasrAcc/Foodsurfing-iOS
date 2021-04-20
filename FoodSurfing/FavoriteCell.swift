//
//  FavoriteCell.swift
//  Foodsurfing
//
//  Created by developer on 13/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCell: UITableViewCell {
    
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var lblRestName: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    var delegate: FavoriteDelegate?
    var index: Int = -1
    
    @IBAction func btnFavAction(_ sender: Any) {
        delegate?.markUnfovorite(atIndex: index)
    }
}
