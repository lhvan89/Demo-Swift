//
//  SettingViewController.swift
//  Dragonball Memory 2
//
//  Created by lhvan on 5/3/17.
//  Copyright © 2017 lhvan. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var sliderMusic: UISlider!
    @IBOutlet weak var sliderSound: UISlider!
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var boardSetting: UIView!
    
    
    
    
    @IBOutlet weak var bgSetting: UIImageView!
    
    var imgBg:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgSetting.image = imgBg
        bgSetting.contentMode = UIViewContentMode.scaleAspectFill
        
        viewSetting.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2)
        boardSetting.layer.cornerRadius = 10

        sliderMusic.value = musicVolume!
        sliderSound.value = soundVolume!
        
        getUserDefault()
        sliderMusic.value = musicVolume!
        sliderSound.value = soundVolume!
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBAction func btnAcloseSetting(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func btnAResetGame(_ sender: UIButton) {
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: "Reset game", message: "Reset game to factory settings.\nYou will lost all high score.\nAre you sure?", preferredStyle: UIAlertControllerStyle.alert)
            let btnOk = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (btn) in
                self.resetGame()
                
                
                let alert2 = UIAlertController(title: "", message: "Reset complete!", preferredStyle: UIAlertControllerStyle.alert)
                let btnOk = UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: { (btn) in
                    soundPlayGame = nil
                    soundMenu = nil
                    soundMenu = playSound(name: "menu", loop: -1)
                    soundMenu?.play()
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                })
                alert2.addAction(btnOk)
                self.present(alert2, animated: true, completion: nil)
            }
            let btnCancel = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel) { (btn) in
            }
            alert.addAction(btnOk)
            alert.addAction(btnCancel)
            present(alert, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }

    }
    
    @IBAction func adjustMusic(_ sender: UISlider) {
        if isMute{
            UserDefaults.standard.set(sliderMusic.value, forKey: "musicVolume")
        }else{
            soundMenu?.volume = sliderMusic.value
            soundPlayGame?.volume = sliderMusic.value
            musicVolume = sliderMusic.value
            UserDefaults.standard.set(sliderMusic.value, forKey: "musicVolume")
        }
    }
    
    @IBAction func adjustSound(_ sender: UISlider) {
        if isMute{
            UserDefaults.standard.set(sliderSound.value, forKey: "soundVolume")
        }else{
            soundVolume = sliderSound.value
            UserDefaults.standard.set(sliderSound.value, forKey: "soundVolume")
            print(sliderSound.value)
        }
    }
    func resetGame(){
        highScore = [
            ["0","00:00","0"],
            ["0","00:00","0"],
            ["0","00:00","0"],
            ["0","00:00","0"],
            ["0","00:00","0"],
            ["0","00:00","0"],
            ["0","00:00","0"]
        ]
        UserDefaults.standard.set(highScore, forKey: "highScore")
        
        newCards = cards
        UserDefaults.standard.set(newCards, forKey: "newCards")
        collectionCards = []
        UserDefaults.standard.set(collectionCards, forKey: "collectionCards")
        
        musicVolume = 1
        soundVolume = 0.5
        
        
        UserDefaults.standard.set(musicVolume, forKey: "musicVolume")
        UserDefaults.standard.set(soundVolume, forKey: "soundVolume")
        UserDefaults.standard.set(musicVolume, forKey: "sliderMusic")
        UserDefaults.standard.set(soundVolume, forKey: "sliderSound")
        
        sliderMusic.value = musicVolume!
        sliderSound.value = soundVolume!
        
        adjustVolume(music: musicVolume, sound: soundVolume)
    }
}
