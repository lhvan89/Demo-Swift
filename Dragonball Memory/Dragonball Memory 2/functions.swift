//
//  functions.swift
//  Dragonball Memory 2
//
//  Created by lhvan on 4/29/17.
//  Copyright © 2017 lhvan. All rights reserved.
//
// threads timer
//tap -> openCard(ani 0.3) -> (delay 0.6)hideQueue(ani 0.3)
//tap -> openCard(ani 0.3) -> (delay 0.6)closeQueue(ani 0.3)
//tap -> (delay 1)checkWin
//tap -> (delay 1.2)finishGame
//tap -> (lock 0.6)tap

import Foundation

import UIKit
import AVFoundation

var newCards:[String]!// các thẻ chưa mở
var collectionCards:[String]! // các thẻ đã mở

var queueButtons:Array<UIButton> = Array<UIButton>()// hàng đợi button đã chọn (2 phần tử)
var queueCards:Array<String> = Array<String>()// hàng đợi tên thẻ đã chọn (2 phần tử)
var arrCards:Array<String> = Array<String>()// mảng các thẻ có trong một màn game
var arrButtons:Array<UIButton> = Array<UIButton>()// mảng các button có trong một màn game

var lockTap:Bool = false

var numTap:Int = 0

var indexTag:Int! // tag button khi chọn thẻ
var countDown:Int!
var gameStart:Bool!
var timerCountDown:Timer!
var gameScore:Int = 0
var limitTime = 0

var highScore:Array<Array<String>>!




var win:Bool = false

var tabHighScore:Int = 0
var soundMenu:AVAudioPlayer?
var soundPlayGame:AVAudioPlayer?
var soundGotItem: AVAudioPlayer?
var arrSoundGotItem = [AVAudioPlayer]()
var soundFlipItem: AVAudioPlayer?
var arrSoundFlipItem = [AVAudioPlayer]()

var soundVolume:Float!
var musicVolume:Float!
var isMute:Bool = false

var queueButtons2:[UIButton]!
var queueCards2:[String]!

var outOfTime:Bool!

var imgBgHome:UIImage!


func initGame(numberOfCards:Int!, lblCards:UILabel!,lblTap:UILabel!){
    
    let randomSound = arc4random_uniform(3) + 1
    if soundPlayGame?.play() == true{
        
    }else{
        
        soundPlayGame = playSound(name: "track0\(randomSound)", loop: -1)
        //adjustVolume(music: musicVolume, sound: soundVolume)
        if isMute == false{
            soundPlayGame?.play()
        }
        
    }

    
    adjustVolume(music: musicVolume, sound: soundVolume)
    soundMenu?.stop()
    

    var arrTemp:[Int] = []
    arrCards.removeAll()
    for i in 0..<numberOfCards{
        arrCards.append("")
        arrTemp.append(i)
    }
    
    for _ in 0...numberOfCards/2-1{
        let ran = Int(arc4random_uniform(UInt32(newCards.count)))
        var push = Int(arc4random_uniform(UInt32(arrTemp.count)))
        arrCards[arrTemp[push]] = newCards[ran]
        arrTemp.remove(at: push)
        push = Int(arc4random_uniform(UInt32(arrTemp.count)))
        arrCards[arrTemp[push]] = newCards[ran]
        arrTemp.remove(at: push)
        
        newCards.remove(at: ran)
        if newCards.count == 0{
            newCards  = cards
        }
        UserDefaults.standard.set(newCards, forKey: "newCards")
    }
    arrCards.shuffle()
    arrCards.shuffle()
    arrCards.shuffle()
    
    lblCards.text = "\(collectionCards.count)"
    lblTap.text = "TAP \(numTap)"
    gameScore = 0
    
    getUserDefault()
    outOfTime = false
}

func getUserDefault(){
    
    if UserDefaults.standard.object(forKey: "newCards") != nil {
        newCards = UserDefaults.standard.object(forKey: "newCards") as! Array<String>
    }else{
        newCards = cards
    }
    
    if UserDefaults.standard.object(forKey: "collectionCards") != nil {
        collectionCards = UserDefaults.standard.object(forKey: "collectionCards") as! Array<String>
    }else{
        collectionCards = []
    }
    
    if UserDefaults.standard.value(forKey: "musicVolume") != nil{
        musicVolume = UserDefaults.standard.value(forKey: "musicVolume") as? Float
    }else{
        musicVolume = 1
        UserDefaults.standard.set(musicVolume, forKey: "musicVolume")
    }
    
    
    
    if UserDefaults.standard.value(forKey: "soundVolume") != nil{
        soundVolume = UserDefaults.standard.value(forKey: "soundVolume") as? Float
    }else{
        soundVolume = 0.5
        UserDefaults.standard.set(soundVolume, forKey: "soundVolume")
    }
    
    if UserDefaults.standard.object(forKey: "highScore") != nil {
        highScore = UserDefaults.standard.object(forKey: "highScore") as? Array<Array<String>>
    }else{
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
    }
}
func openCard(button:UIButton, images:String){
    let img = UIImage(named: images)
    button.setImage(img, for: .normal)
    button.isUserInteractionEnabled = false
    UIView.transition(with: button, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: nil, completion: nil)

}
func resetGame(){
    win = false
    outOfTime = false
    numTap = 0
    queueButtons.removeAll()
    queueCards.removeAll()
    arrCards.removeAll()
    arrButtons.removeAll()
    gameStart = false
    
    arrSoundFlipItem.removeAll()
    arrSoundGotItem.removeAll()
    if timerCountDown != nil{
        timerCountDown.invalidate()
        timerCountDown = nil
    }
    
}
func intToTime(number:Int!) -> String{
    return "\((number/60<10) ? "0\(number/60)":"\(number/60)"):\((number%60<10) ? "0\(number%60)":"\(number%60)")"
}

func playSound(name:String,loop:Int) -> AVAudioPlayer?{
    var soundFromFile:AVAudioPlayer?
    let url = Bundle.main.url(forResource: name, withExtension: "mp3")!
    
    do {
        soundFromFile = try AVAudioPlayer(contentsOf: url)
        guard let soundFromFile = soundFromFile else { return nil }
        
        soundFromFile.prepareToPlay()
        //soundFromFile.play()
        soundFromFile.numberOfLoops = loop
    } catch let error {
        print(error.localizedDescription)
    }
    return soundFromFile
}
func adjustVolume(music:Float, sound:Float){
    soundMenu?.volume = music
    soundPlayGame?.volume = music
    soundFlipItem?.volume = sound
    soundGotItem?.volume = sound
}
func setIconSound(button:UIButton){
    getUserDefault()
    if isMute{
        adjustVolume(music: 0, sound: 0)
        button.setImage(#imageLiteral(resourceName: "mute"), for: .normal)
        soundMenu?.pause()
        soundPlayGame?.pause()

    }else{
        button.setImage(#imageLiteral(resourceName: "sound"), for: .normal)
        adjustVolume(music: musicVolume, sound: soundVolume)
        soundMenu?.play()
        soundPlayGame?.play()
    }
}
class fnTimer{
    @objc func unLockTap(){
        lockTap = false
    }
    @objc func hideQueue(){
        if #available(iOS 8, *) {
            UIView.animate(withDuration: 0.3, animations: {
                queueButtons2[0].transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                queueButtons2[1].transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }) { (true) in
                queueButtons2[0].isHidden = true
                queueButtons2[1].isHidden = true
                queueButtons2[0].transform = CGAffineTransform(scaleX: 1, y: 1)
                queueButtons2[1].transform = CGAffineTransform(scaleX: 1, y: 1)
                
                //queueButtons.removeAll()
            }
        } else {
            queueButtons2[0].isHidden = true
            queueButtons2[1].isHidden = true
            //queueCards.removeAll()
            //queueButtons.removeAll()
        }
        if outOfTime == false{
            gameScore = gameScore + countDown
        }
        
        
        //---------- play gotItem sound ----------
        soundGotItem = playSound(name: "gotItem", loop: 0)
        soundGotItem?.volume = soundVolume
        arrSoundGotItem.append(soundGotItem!)
        arrSoundGotItem.last?.play()
        //---------- end play gotItem sound ----------
    }
    @objc func closeQueue(){
        
        closeCard(button: queueButtons2[0])
        closeCard(button: queueButtons2[1])
        
    }
    func closeCard(button:UIButton){
        //let img = UIImage(named: "ball\(curLevel!)_back")
        button.setImage(#imageLiteral(resourceName: "card_back2"), for: .normal)
        //print("ball\(curLevel)_back")
        button.isUserInteractionEnabled = true
        UIView.transition(with: button, duration: 0.3, options: UIViewAnimationOptions.transitionFlipFromRight, animations: nil, completion: nil)
    }
    @objc func checkWin(){ // for timer
        var count = 0
        for i in arrButtons{
            if i.isHidden{
                count += 1
            }
        }
        if count == arrButtons.count{
            win = true
        }
    }
}
class functionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    static func playFlipSound(){
        
    }
    static func btna(lblTap:UILabel){
        if gameStart == false{
            gameStart = true
        }
        
        let fn:fnTimer = fnTimer()
        if lockTap {
            return
        }
        //---------- play flip sound ----------
        soundFlipItem = playSound(name: "flipItem", loop: 0)
        soundFlipItem?.volume = soundVolume
        arrSoundFlipItem.append(soundFlipItem!)
        
        arrSoundFlipItem.last?.play()
        //---------- end play flip sound ----------
        
        numTap = numTap + 1
        lblTap.text = "TAP \(numTap)"
        
        openCard(button: arrButtons[indexTag], images: "\(arrCards[indexTag]).png")
        queueCards.append("\(arrCards[indexTag]).png")
        queueButtons.append(arrButtons[indexTag])
        if queueButtons.count == 2 {
            queueCards2 = queueCards
            queueButtons2 = queueButtons
            queueButtons.removeAll()
            queueCards.removeAll()
            if queueCards2[0] == queueCards2[1]{
                lockTap = true
                Timer.scheduledTimer(timeInterval: 0.9, target: fn, selector:#selector(fnTimer.unLockTap), userInfo: nil, repeats: false)
                collectionCards.append(queueCards2[0])
                UserDefaults.standard.set(collectionCards, forKey: "collectionCards")
                var count = 0
                for i in arrButtons{
                    if i.isHidden{
                        count += 1
                    }
                }
                Timer.scheduledTimer(timeInterval: 0.6, target: fn, selector: #selector(fnTimer.hideQueue), userInfo: nil, repeats: false)
                if count == arrButtons.count - 2{
                    timerCountDown.invalidate()
                    timerCountDown = nil
                    Timer.scheduledTimer(timeInterval: 1, target: fn, selector: #selector(fnTimer.checkWin), userInfo: nil, repeats: false)
                }
            }else{
                lockTap = true
                Timer.scheduledTimer(timeInterval: 0.6, target: fn, selector:#selector(fnTimer.unLockTap), userInfo: nil, repeats: false)
                Timer.scheduledTimer(timeInterval: 0.6, target: fn, selector: #selector(fnTimer.closeQueue), userInfo: nil, repeats: false)
            }
        }
    }
}
extension Array{
    mutating func shuffle(){
        for i in 0..<count-1{
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            let temp = self[i]
            self[i] = self[j]
            self[j] = temp
        }
    }
}
