//
//  HowWorksPageViewController.swift
//  Foodsurfing
//
//  Created by developer on 16/10/2017.
//  Copyright © 2017 Foodsurfing GmbH - Muhammad Adeel. All rights reserved.
//

import Foundation
import UIKit

class HowWorksPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "HowItWorks", bundle: nil).instantiateViewController(withIdentifier: "firstVC"),
            UIStoryboard(name: "HowItWorks", bundle: nil).instantiateViewController(withIdentifier: "secondVC"),
            UIStoryboard(name: "HowItWorks", bundle: nil).instantiateViewController(withIdentifier: "thirdVC"),
            UIStoryboard(name: "HowItWorks", bundle: nil).instantiateViewController(withIdentifier: "forthVC")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    func navigateToScreen(withIndex: Int) {
        if withIndex == 0 {
            if let firstViewController = orderedViewControllers.first {
                setViewControllers([firstViewController],
                                   direction: .reverse,
                                   animated: true,
                                   completion: nil)
            }
        }
        else if withIndex == 1 {
            if let firstViewController = orderedViewControllers.last {
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        let parentVC = self.parent as! HowItWorksController
        parentVC.pageControl.currentPage = (orderedViewControllers.index(of: (pageViewController.viewControllers?.first)!) ?? 0)
        if parentVC.pageControl.currentPage == 3 {
            parentVC.btnSkip.isHidden = true
            parentVC.btnNext.isHidden = true
            parentVC.btnDone.isHidden = false
        }
        else {
            parentVC.btnSkip.isHidden = false
            parentVC.btnNext.isHidden = false
            parentVC.btnDone.isHidden = true
        }
    }
    
}

extension UIPageViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let currentViewController = viewControllers?[0] {
            if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
                setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
            }
        }
    }
}
