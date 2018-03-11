//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by lhvan on 3/7/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
import PageMenu

class MovieViewController: UIViewController {
    
    class func newVC(title: String) -> MovieViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc  = storyboard.instantiateViewController(withIdentifier: "movieVC") as! MovieViewController
        vc.title = title
        return vc
    }
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MovieViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableCell", for: indexPath) as! MovieTableViewCell
        return cell
    }
}
















