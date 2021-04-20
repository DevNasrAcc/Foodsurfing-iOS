//
//  CalendarView.swift
//  Foodsurfing
//
//  Created by developer on 21/09/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class CalendarView: UIView {
    
    var delegate: DateSelectionDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
    
    class func instanceFromNib(del: DateSelectionDelegate) -> UIView {
        let instance = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CalendarView
        instance.datePicker.setValue(UIColor.white, forKey: "textColor")
        instance.delegate = del
        return instance
    }
    
    @IBAction func actionDateSelected(_ sender: Any) {
        let selectedDate = self.datePicker.date
        self.delegate?.onDateSelected(selectedDate: selectedDate)
        self.removeFromSuperview()
    }
    
}
