//
//  ViewController.swift
//  2048
//
//  Created by lhvan on 6/1/17.
//  Copyright © 2017 lhvan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var labelGrid0: UILabel!
    @IBOutlet weak var labelGrid1: UILabel!
    @IBOutlet weak var labelGrid2: UILabel!
    @IBOutlet weak var labelGrid3: UILabel!
    @IBOutlet weak var labelGrid4: UILabel!
    @IBOutlet weak var labelGrid5: UILabel!
    @IBOutlet weak var labelGrid6: UILabel!
    @IBOutlet weak var labelGrid7: UILabel!
    @IBOutlet weak var labelGrid8: UILabel!
    @IBOutlet weak var labelGrid9: UILabel!
    @IBOutlet weak var labelGrid10: UILabel!
    @IBOutlet weak var labelGrid11: UILabel!
    @IBOutlet weak var labelGrid12: UILabel!
    @IBOutlet weak var labelGrid13: UILabel!
    @IBOutlet weak var labelGrid14: UILabel!
    @IBOutlet weak var labelGrid15: UILabel!
    
    @IBOutlet weak var labelGameScore: UILabel!
    @IBOutlet weak var labelHighScore: UILabel!

    @IBOutlet weak var viewGameOver: UIView!
    @IBOutlet weak var viewHighScore: UIView!
    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var buttonTryAgain: UIButton!
    @IBOutlet weak var buttonNewGame: UIButton!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var viewAds: GADBannerView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrLabelGrid = [
            [labelGrid0,labelGrid1,labelGrid2,labelGrid3],
            [labelGrid4,labelGrid5,labelGrid6,labelGrid7],
            [labelGrid8,labelGrid9,labelGrid10,labelGrid11],
            [labelGrid12,labelGrid13,labelGrid14,labelGrid15]
        ]
        numberOffRows = arrLabelGrid.count
        
        initGame(numberOffRows: numberOffRows)
        
        labelGameScore.text = "\(0)"
        
        if UserDefaults.standard.value(forKey: "highScore") != nil {
            highScore = UserDefaults.standard.value(forKey: "highScore") as! Double
        }
        labelHighScore.text = "\(highScore)".replacingOccurrences(of: ".0", with: "")
        
        
        
        viewGameOver.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.4)
        viewScore.radius(withRadius: 3)
        viewHighScore.radius(withRadius: 3)
        buttonTryAgain.radius(withRadius: 3)
        buttonNewGame.radius(withRadius: 3)
        
        let randomAnonymousUser = Int(arc4random_uniform(UInt32(arrUserAnonymous.count)))
        
        labelUserName.text = arrUserAnonymous[randomAnonymousUser][1]
        imageAvatar.image = UIImage(named: arrUserAnonymous[randomAnonymousUser][2])
        
        // Google AddMod
        
        viewAds.adUnitID = "ca-app-pub-5914036266764762/4891456930"
        viewAds.rootViewController = self
        viewAds.load(GADRequest())
    }
    
    @IBAction func swipeGestureLeft(_ sender: UISwipeGestureRecognizer) {
        if endGame {return}
        arrBackUpDataGrid = arrDataGrid
        pullLeft()
        
        for i in 0..<numberOffRows {
            for j in 0..<numberOffRows-1 {
                if arrDataGrid[i][j] == arrDataGrid[i][j+1] {
                    arrDataGrid[i][j] *= 2
                    updateScore(addScore: arrDataGrid[i][j])
                    arrDataGrid[i][j+1] = 0
                }
            }
        }
        pullLeft()
        if canNotMove() {
        }else {
            initItem()
            drawGrid()
        }
        if checkEndGame(){
            finishGame()
        }
    }
    
    @IBAction func swipeGestureRight(_ sender: UISwipeGestureRecognizer) {
        if endGame {return}
        arrBackUpDataGrid = arrDataGrid
        pullRight()
        
        for i in 0..<numberOffRows {
            for j in 0..<numberOffRows-1 {
                if arrDataGrid[i][numberOffRows-1-j] == arrDataGrid[i][numberOffRows-1-j-1] {
                    arrDataGrid[i][numberOffRows-1-j] *= 2
                    updateScore(addScore: arrDataGrid[i][numberOffRows-1-j])
                    arrDataGrid[i][numberOffRows-1-j-1] = 0
                }
            }
        }
        pullRight()
        if canNotMove() {
        }else {
            initItem()
            drawGrid()
        }
        if checkEndGame(){
            finishGame()
        }
        
    }
    
    @IBAction func swipeGestureUp(_ sender: UISwipeGestureRecognizer) {
        if endGame {return}
        arrBackUpDataGrid = arrDataGrid
        pullUp()
        for i in 0..<numberOffRows {
            for j in 0..<numberOffRows-1 {
                if arrDataGrid[j][i] == arrDataGrid[j+1][i] {
                    arrDataGrid[j][i] *= 2
                    updateScore(addScore: arrDataGrid[j][i])
                    arrDataGrid[j+1][i] = 0
                }
            }
        }
        pullUp()
        if canNotMove() {
        }else {
            initItem()
            drawGrid()
        }
        if checkEndGame(){
            finishGame()
        }
    }
    
    @IBAction func swipeGestureDown(_ sender: UISwipeGestureRecognizer) {
        if endGame {return}
        arrBackUpDataGrid = arrDataGrid
        pullDown()
        for i in 0..<numberOffRows {
            for j in 0..<numberOffRows-1 { //0,1,2
                if arrDataGrid[numberOffRows-1-j][i] == arrDataGrid[numberOffRows-1-j-1][i] {
                    arrDataGrid[numberOffRows-1-j][i] *= 2
                    updateScore(addScore: arrDataGrid[numberOffRows-1-j][i])
                    arrDataGrid[numberOffRows-1-j-1][i] = 0
                }
            }
        }
        pullDown()
        if canNotMove() {
        }else {
            initItem()
            drawGrid()
        }
        if checkEndGame(){
            finishGame()
            
        }
    }
    
    func checkEndGame() -> Bool {
        for i in 0..<numberOffRows {
            for j in 0..<numberOffRows-1 {
                if arrDataGrid[i][j] == arrDataGrid[i][j+1] || arrDataGrid[j][i] == arrDataGrid[j+1][i] || arrDataGrid[i][j] == 0 || arrDataGrid[i][j+1] == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func finishGame(){
        endGame = true
        if gameScore > highScore{
            highScore = gameScore
            UserDefaults.standard.set(highScore, forKey: "highScore")
            labelHighScore.text = "\(highScore)".replacingOccurrences(of: ".0", with: "")
        }
        viewGameOver.isHidden = false
    }
    
    func updateScore(addScore score: Int) {
        gameScore += Double(score)
        labelGameScore.text = "\(gameScore)".replacingOccurrences(of: ".0", with: "")
    }
    
    @IBAction func buttonReload(_ sender: UIButton) {
        labelGameScore.text = "\(0)"
        gameScore = 0
        arrDataGrid = [
            [0,0,0,0],
            [0,0,0,0],
            [0,0,0,0],
            [0,0,0,0]
        ]
        endGame = false
        initItem()
        drawGrid()
        viewGameOver.isHidden = true
    }
}


extension UIView {
    func radius(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
extension UIButton {
    func borderRadius(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

























