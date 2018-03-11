//
//  HomeViewController.swift
//  Dragonball Memory 2
//
//  Created by lhvan on 4/30/17.
//  Copyright © 2017 lhvan. All rights reserved.
//

import UIKit
class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var bgHome: UIImageView!
    
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var imgBallAct1: UIImageView!
    @IBOutlet weak var imgBallAct2: UIImageView!
    @IBOutlet weak var imgBallAct3: UIImageView!
    @IBOutlet weak var imgBallAct4: UIImageView!
    @IBOutlet weak var imgBallAct5: UIImageView!
    @IBOutlet weak var imgBallAct6: UIImageView!
    @IBOutlet weak var imgBallAct7: UIImageView!
    
    @IBOutlet weak var btnSound: UIButton!
    

    @IBOutlet weak var viewControl: UIView!
    
    @IBOutlet weak var viewLevel: UIView!
    
    var arrBallAct:[UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let bg = arc4random_uniform(2) + 1
        //imgBgHome = UIImage(named: "bgHome\(bg)")
        //bgHome.image = #imageLiteral(resourceName: "bgHome2")
        
        soundMenu = playSound(name: "menu", loop: -1)
        
        
        //playSoundGotItem()
        //playSoundFlipItem()
        
        getUserDefault()
        
        adjustVolume(music: musicVolume, sound: soundVolume)
        
        
        
        arrBallAct = [imgBallAct1,imgBallAct2,imgBallAct3,imgBallAct4,imgBallAct5,imgBallAct6,imgBallAct7]
        Timer.scheduledTimer(timeInterval: 0.375, target: self, selector: #selector(HomeViewController.shining), userInfo: nil, repeats: true)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        viewControl.layer.cornerRadius = viewControl.frame.size.height / 8
        viewControl.clipsToBounds = true
        viewControl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.8)
        
        viewLevel.layer.cornerRadius = viewLevel.frame.size.width/2
        viewLevel.clipsToBounds = true
        viewLevel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.4)
        setIconSound(button: btnSound)
        if isMute == false{
            soundMenu?.play()
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBAction func btnAHighScore(_ sender: UIButton) {
        let highScoreScr = storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController")
        present(highScoreScr!, animated: false, completion: nil)
    }
    
    @IBAction func btnASetting(_ sender: UIButton) {
        let settingScr = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        settingScr.imgBg = #imageLiteral(resourceName: "bgHome")
        present(settingScr, animated: false, completion: nil)
    }
    
    @IBAction func btnSelectLevel(_ sender: UIButton) {
        soundMenu = nil
        let target = storyboard?.instantiateViewController(withIdentifier: "Lv\(sender.tag)ViewController")
        present(target!, animated: true, completion: nil)
    }
    
    func shining(){
        for i in arrBallAct{
            UIView.animate(withDuration: 0.375, animations: {
                i.alpha = i.alpha == 1 ? 0 : 1
            })
        }
//        UIView.animate(withDuration: 0.375, animations: {
//            self.lblLevel.alpha = self.lblLevel.alpha == 0.8 ? 0 : 0.8
//        })
        
    }
    @IBAction func btnASound(_ sender: UIButton) {
        if isMute{
            isMute = false
            setIconSound(button: btnSound)
        }else{
            isMute = true
            setIconSound(button: btnSound)
        }
    }

}

extension UIButton{
    func ghostButton(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
