//
//  FinderSearchViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 23/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

@objc protocol FinderSearchViewControllerDelegate {
    optional func toggleRightPanel()
}

class FinderSearchViewController: UIViewController, FinderSlideOutMenuViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: FinderSearchViewControllerDelegate?
    
    var ImageArray = [UIImage(named: "baby"),UIImage(named: "core"),UIImage(named: "functional"),UIImage(named: "rehab"),UIImage(named: "smallGroup"),UIImage(named: "weightLoss")]
    let trainingTypesArray = ["Pre and Post Baby","Core Strength","Functional Training","Rehab","Small Group Training","Weight Loss"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBarButtonItemPressed(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func MenuBarButtonItemPressed(sender: UIBarButtonItem) {
        if let d = delegate {
            d.toggleRightPanel?()
        }
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
