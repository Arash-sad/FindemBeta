//
//  FinderSearchViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 23/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse


class FinderSearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var slidingMenu = UIView.loadFromNibNamed("SlidingMenu")
    var menuVisible = false
    var menuHeight:CGFloat = 150
    
    var ImageArray = [UIImage(named: "baby"),UIImage(named: "core"),UIImage(named: "functional"),UIImage(named: "rehab"),UIImage(named: "smallGroup"),UIImage(named: "weightLoss")]
    let trainingTypesArray = ["Pre and Post Baby","Core Strength","Functional Training","Rehab","Small Group Training","Weight Loss"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slidingMenu?.frame.size.width = self.view.frame.size.width
        slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: -170)
        view.addSubview(slidingMenu!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func MenuBarButtonItemTapped(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.menuVisible = !self.menuVisible
            var height:CGFloat = self.menuHeight
            if self.menuVisible == false {
                height = -self.menuHeight
            }
            self.slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: height)
            
            }, completion: { finished in
                
                
        })

    }

}

extension FinderSearchViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchCell", forIndexPath: indexPath) as! SearchCollectionViewCell
        cell.imageView.image = self.ImageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showSearchResult", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSearchResult"{
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            let resultVC = segue.destinationViewController as! FinderSearchResultViewController
            resultVC.trainingType = self.trainingTypesArray[indexPath.row]
            
        }
    }
}

