//
//  BaseViewController.swift
//  Movie App
//
//  Created by lhvan on 11/4/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var page = 1
    var isFirstLoad = true
    let refeshing = UIRefreshControl()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
