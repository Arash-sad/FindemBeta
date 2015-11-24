//
//  FinderResultViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 24/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class FinderResultViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var dataObject: AnyObject?
//    var name: String?
//    var favorite: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.loadHTMLString(dataObject as! String,
            baseURL: NSURL(string: ""))
//        nameLabel.text = name
//        favoriteLabel.text = favorite
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
