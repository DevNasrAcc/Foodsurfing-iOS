//
//  LoadingView.swift
//  Foodsurfing
//
//  Created by developer on 24/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var txtView: UITextView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = CGFloat(5)
    }
    
    class func instanceFromNib() -> UIView {
        let loadingView = UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingView
        loadingView.txtView.text = "Bitte warten..."
        return loadingView
    }
    
}
