//
//  HowItWorksController.swift
//  Foodsurfing
//
//  Created by developer on 16/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class HowItWorksController: UIViewController {
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var childPageVC: HowWorksPageViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? "") == "toPageViewController" {
            let vc = segue.destination as! HowWorksPageViewController
            self.childPageVC = vc
        }
    }
    
    @IBAction func btnSkipAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        childPageVC?.goToNextPage()
        if self.pageControl.currentPage < 3 {
            self.pageControl.currentPage = self.pageControl.currentPage+1
        }
        
        if self.pageControl.currentPage == 3 {
            self.btnSkip.isHidden = true
            self.btnNext.isHidden = true
            self.btnDone.isHidden = false
        }
    }    
}
