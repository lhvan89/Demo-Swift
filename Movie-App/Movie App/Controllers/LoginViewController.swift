
//
//  LoginViewController.swift
//  Movie App
//
//  Created by lhvan on 12/1/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    static let identifier = "loginVC"
    
    var params:[String:Any]?
    
    class func newVC() -> LoginViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! LoginViewController
    }
    
    @IBOutlet weak var userId: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(params)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if let params = self.params {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "continueAction"), object: nil, userInfo: params)
            self.dismiss(animated: true, completion: {
                
            })
        }
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
