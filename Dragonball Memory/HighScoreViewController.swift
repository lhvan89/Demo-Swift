//
//  HighScoreViewController.swift
//  Dragonball Memory 2
//
//  Created by lhvan on 5/4/17.
//  Copyright © 2017 lhvan. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    
    @IBOutlet weak var btnHs1: UIButton!
    @IBOutlet weak var btnHs2: UIButton!
    @IBOutlet weak var btnHs3: UIButton!
    @IBOutlet weak var btnHs4: UIButton!
    @IBOutlet weak var btnHs5: UIButton!
    @IBOutlet weak var btnHs6: UIButton!
    @IBOutlet weak var btnHs7: UIButton!
    
    @IBOutlet weak var viewHighScore: UIView!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTap: UILabel!
    
    var arrBtnHs:[UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrBtnHs = [btnHs1, btnHs2, btnHs3, btnHs4, btnHs5,btnHs6,btnHs7]
        
        
        //viewHighScore.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        
        activeButton(btn: arrBtnHs[tabHighScore])
        
        getUserDefault()
        
        lblScore.text = "\(highScore[tabHighScore][0])"
        lblTime.text = "\(highScore[tabHighScore][1])"
        lblTap.text = "\(highScore[tabHighScore][2])"
        
        viewResult.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        viewResult.layer.borderWidth = 1
        viewResult.layer.cornerRadius = 10
        viewResult.clipsToBounds = true
        
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    @IBAction func btnACloseHighScore(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnShowScore(_ sender: UIButton) {
        deactiveButton()
        let index = sender.tag
        tabHighScore = index
        activeButton(btn: arrBtnHs[index])
        getUserDefault()
        lblScore.text = "\(highScore[index][0])"
        lblTime.text = "\(highScore[index][1])"
        lblTap.text = "\(highScore[index][2])"
    }
    func deactiveButton(){
        for (index,value) in arrBtnHs.enumerated(){
            let img = UIImage(named: "ball\(index+1)_dis")
            value.setImage(img, for: .normal)
        }
    }
    func activeButton(btn:UIButton){
        deactiveButton()
        let img = UIImage(named: "ball\(btn.tag+1)")
        btn.setImage(img, for: .normal)
        
    }
}
