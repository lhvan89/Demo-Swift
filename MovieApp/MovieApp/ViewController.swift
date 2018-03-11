//
//  ViewController.swift
//  MovieApp
//
//  Created by lhvan on 3/7/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
import PageMenu

class ViewController: UIViewController {
    var pageMenu : CAPSPageMenu?
    
    @IBOutlet weak var wrapperPageMenuView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Array to keep track of controllers in page menu
        var controllerArray : [MovieViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        
        let topRatedVC = MovieViewController.newVC(title: "Top Rated")
        controllerArray.append(topRatedVC)
        
        let popularVC = MovieViewController.newVC(title: "Popular")
        controllerArray.append(popularVC)
        
        let nowPlayingVC = MovieViewController.newVC(title: "Now Playing")
        controllerArray.append(nowPlayingVC)
        
        let upComingVC = MovieViewController.newVC(title: "Up Coming")
        controllerArray.append(upComingVC)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .viewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(40.0),
            .menuItemWidth(90.0),
            .centerMenuItems(true)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height:self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        wrapperPageMenuView.addSubview(pageMenu!.view)
        
        pageMenu?.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

