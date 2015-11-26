//
//  FinderPageViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 24/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class FinderPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController: UIPageViewController?
    var pageContent = NSArray()
    //TEMP
    var nameArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createResultPages()
        print("@#$%^")
        print(nameArray)
        pageController = UIPageViewController(
            transitionStyle: .Scroll,
            navigationOrientation: .Horizontal,
            options: nil)
        
        pageController?.delegate = self
        pageController?.dataSource = self
        
        let startingViewController: FinderResultViewController =
        viewControllerAtIndex(0)!
        
        let viewControllers: NSArray = [startingViewController]
        pageController!.setViewControllers(viewControllers as? [UIViewController],
            direction: .Forward,
            animated: false,
            completion: nil)
        
        self.addChildViewController(pageController!)
        self.view.addSubview(self.pageController!.view)
        
        let pageViewRect = self.view.bounds
        pageController!.view.frame = pageViewRect    
        pageController!.didMoveToParentViewController(self)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createResultPages() {
        var pageStrings = [String]()
        
        for i in 1...11
        {
            let contentString = "<html><head></head><body><br><h1>Chapter \(i)</h1><p>This is the page \(i) of content displayed using UIPageViewController in iOS 8.</p></body></html>"
            pageStrings.append(contentString)
        }
        pageContent = pageStrings
    }
    
    // Convenience Methods
    func viewControllerAtIndex(index: Int) -> FinderResultViewController? {
        
        if (pageContent.count == 0) ||
            (index >= pageContent.count) {
                return nil
        }
        
        let storyBoard = UIStoryboard(name: "Main",
            bundle: NSBundle.mainBundle())
        let dataViewController = storyBoard.instantiateViewControllerWithIdentifier("result") as! FinderResultViewController
        
        dataViewController.dataObject = pageContent[index]
        return dataViewController
    }
    
    func indexOfViewController(viewController: FinderResultViewController) -> Int {
        
        if let dataObject: AnyObject = viewController.dataObject {
            return pageContent.indexOfObject(dataObject)
        } else {
            return NSNotFound
        }
    }
    
    // UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController
            as! FinderResultViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController
            as! FinderResultViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == pageContent.count {
            return nil
        }
        return viewControllerAtIndex(index)
    }


}
