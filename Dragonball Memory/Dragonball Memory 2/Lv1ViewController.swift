//
//  Lv1ViewController.swift
//  Dragonball Memory 2
//
//  Created by lhvan on 5/2/17.
//  Copyright © 2017 lhvan. All rights reserved.
//

import UIKit

class Lv1ViewController: UIViewController {
    
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    
    
    @IBOutlet weak var lblCollectionCards: UILabel!
    
    @IBOutlet weak var lblTap: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblScore: UILabel!

    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var viewValueResult: UIView!

    @IBOutlet weak var lblTitleResult: UILabel!
    @IBOutlet weak var lblScoreResult: UILabel!
    @IBOutlet weak var lblTimeResult: UILabel!
    @IBOutlet weak var lblTapResult: UILabel!
    
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    @IBOutlet weak var manaArea: UIView!
    @IBOutlet weak var mana: UIView!
    var manaWidth:CGFloat!
    @IBOutlet weak var lblOutOfTime: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //curLevel = 1
        resetGame()
        initGame(numberOfCards: 8, lblCards:lblCollectionCards,lblTap:lblTap)
        arrButtons = [btn0,btn1,btn2,btn3,btn4,btn5,btn6,btn7]
        limitTime = 20
        countDown = limitTime
        viewResult.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        setIconSound(button: btnSound)
        lblOutOfTime.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        manaArea.layer.cornerRadius = manaArea.frame.height / 2
        manaArea.clipsToBounds = true
        manaWidth = mana.frame.size.width
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnASetting(_ sender: UIButton) {
        if gameStart == true{
            if countDown > 0{
                
            }else{
                playPause()
            }
            
        }
        let settingScr = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        settingScr.imgBg = UIImage(named: "background3.jpg")
        present(settingScr, animated: false, completion: nil)
    }
    @IBAction func btnAPlayPause(_ sender: UIButton) {
        if countDown > 0 {
            
        }else{
            playPause()
        }
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
    
    @IBAction func btnATapone(_ sender: UIButton) {
        if gameStart == false{
            playPause()
        }
        indexTag = sender.tag
        tap()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Lv1ViewController.updateValue), userInfo: nil, repeats: false)
            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(Lv1ViewController.finishGame), userInfo: nil, repeats: false)
        
    }
    
    @IBAction func btnAHome(_ sender: UIButton) {
        resetGame()
        soundPlayGame = nil
        soundMenu = nil
        soundMenu = playSound(name: "menu", loop: -1)
        soundMenu?.volume = musicVolume
        if isMute == false{
            soundMenu?.play()
        }
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAReload(_ sender: UIButton) {
        playPause()
        mana.frame.size.width = manaWidth
        btnPlayPause.isUserInteractionEnabled = true
        btnPlayPause.alpha = 1
        lblOutOfTime.alpha = 0

        resetGame()
        initGame(numberOfCards: 8, lblCards:lblCollectionCards,lblTap:lblTap)
        arrButtons = [btn0,btn1,btn2,btn3,btn4,btn5,btn6,btn7]
        countDown = limitTime
        gameScore = 0
        lblScore.text = "SCORE \(gameScore)"
        lblTime.text = "TIME \(intToTime(number: 0))"
        
        for i in arrButtons{
            
            i.setImage(#imageLiteral(resourceName: "card_back2"), for: .normal)
            i.isUserInteractionEnabled = true
            i.isHidden = false
        }
        viewResult.isHidden = true
    }
    
    @IBAction func btnABack(_ sender: UIButton) {
        resetGame()
        soundPlayGame = nil
        soundMenu = nil
        soundMenu = playSound(name: "menu", loop: -1)
        soundMenu?.volume = musicVolume
        if isMute == false{
            soundMenu?.play()
        }
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnANext(_ sender: UIButton) {
        let nextScr = storyboard?.instantiateViewController(withIdentifier: "Lv2ViewController")
        present(nextScr!, animated: true, completion: nil)
    }
    
    func tap(){
        functionViewController.btna(lblTap: lblTap)
    }
    func finishGame(){
        if win{
            btnPlayPause.isUserInteractionEnabled = false
            btnPlayPause.alpha = 0.2
            let index = 0
            if Int(highScore[index][0])! >= gameScore {
                lblTitleResult.text = "FINISH!"
                lblScoreResult.text =  "\(gameScore) / (🏆\(highScore[index][0]))"
            }else{
                lblTitleResult.text = "NEW RECORD!"
                lblScoreResult.text =  "🏆\(gameScore)"
                
                highScore[index] = ["\(gameScore)",intToTime(number: limitTime - countDown),"\(numTap)"]
                UserDefaults.standard.set(highScore, forKey: "highScore")
                win = false
            }
            tabHighScore = index
            lblTimeResult.text = intToTime(number: limitTime - countDown)
            lblTapResult.text = "\(numTap)"
            viewValueResult.isHidden = false
            viewResult.isHidden = false
        }
    }
    func updateValue(){
        lblCollectionCards.text = "\(collectionCards.count)"
        if outOfTime == false{
            lblScore.text = "SCORE \(gameScore)"
        }
    }
    func timeLeft(){
        countDown = countDown - 1
        if countDown >= 0{
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.mana.frame.size.width = CGFloat((Float(countDown) * Float(self.manaWidth)) / Float(limitTime))
            }, completion: nil)
        }else{
            btnPlayPause.alpha = 1
            btnPlayPause.isUserInteractionEnabled = true
            if outOfTime == false {
                outOfTime = true
                UIView.animate(withDuration: 1, animations: { 
                    self.lblOutOfTime.alpha = 1
                })
            }
        }
        lblTime.text = "TIME \(intToTime(number: limitTime - countDown))"
    }
    func playPause(){
        if countDown > 0 {
            btnPlayPause.isUserInteractionEnabled = false
            btnPlayPause.alpha = 0.2
        }
        if gameStart == true{
            if timerCountDown != nil{
                timerCountDown.invalidate()
                soundPlayGame?.pause()
            }
            gameStart = false
            btnPlayPause.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }else{
            gameStart = true
            btnPlayPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            timerCountDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Lv1ViewController.timeLeft), userInfo: self, repeats: true)
            soundPlayGame?.play()
        }
    }
}
