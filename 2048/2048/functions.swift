//
//  functions.swift
//  2048
//
//  Created by lhvan on 6/3/17.
//  Copyright © 2017 lhvan. All rights reserved.
//

import Foundation
import UIKit


var numberOffRows:Int!
var arrDataGrid:[[Int]] = []
var arrBackUpDataGrid:[[Int]] = []
var arrLabelGrid:[[UILabel]] = []
var endGame:Bool = false
var gameScore:Double = 0
var highScore:Double = 0

func pullLeft() {
    for i in 0..<numberOffRows {
        for j in 0..<numberOffRows-1 {
            if arrDataGrid[i][j] == 0 {
                for k in stride(from: j+1,through:numberOffRows-1,by:1) {
                    if arrDataGrid[i][k] != 0 {
                        arrDataGrid[i][j] = arrDataGrid[i][k]
                        arrDataGrid[i][k] = 0
                        break
                    }
                }
            }
        }
    }
}
func pullRight() {
    for i in 0..<numberOffRows {
        for j in 0..<numberOffRows-1 {
            if arrDataGrid[i][numberOffRows-1-j] == 0 {
                for k in stride(from: numberOffRows-1-j-1,through:0,by:-1) {
                    if arrDataGrid[i][k] != 0 {
                        arrDataGrid[i][numberOffRows-1-j] = arrDataGrid[i][k]
                        arrDataGrid[i][k] = 0
                        break
                    }
                }
            }
        }
    }
}
func pullUp() {
    for i in 0..<numberOffRows {
        for j in 0..<numberOffRows-1 {
            if arrDataGrid[j][i] == 0 {
                for k in stride(from: j+1, through: numberOffRows-1, by: 1) {
                    if arrDataGrid[k][i] != 0 {
                        arrDataGrid[j][i] = arrDataGrid[k][i]
                        arrDataGrid[k][i] = 0
                        break
                    }
                }
            }
        }
    }
}
func pullDown() {
    for i in 0..<numberOffRows {
        for j in 0..<numberOffRows-1 {
            if arrDataGrid[numberOffRows-1-j][i] == 0 {
                for k in stride(from: numberOffRows-1-j-1, through: 0, by: -1) {
                    if arrDataGrid[k][i] != 0 {
                        arrDataGrid[numberOffRows-1-j][i] = arrDataGrid[k][i]
                        arrDataGrid[k][i] = 0
                        break
                    }
                }
            }
        }
    }
}

func canNotMove() -> Bool {
    for i in 0..<numberOffRows {
        for j in 0..<numberOffRows {
            if arrBackUpDataGrid[i][j] != arrDataGrid[i][j] {
                return false
            }
        }
    }
    return true
}
func drawGrid() {
    let arrColor = ["0":#colorLiteral(red: 0.9333333333, green: 0.8941176471, blue: 0.8549019608, alpha: 0.3514822346),"2":#colorLiteral(red: 0.9333333333, green: 0.8941176471, blue: 0.8549019608, alpha: 1),"4":#colorLiteral(red: 0.9294117647, green: 0.8784313725, blue: 0.7843137255, alpha: 1),"8":#colorLiteral(red: 0.9490196078, green: 0.6941176471, blue: 0.4745098039, alpha: 1),"16":#colorLiteral(red: 0.9607843137, green: 0.5843137255, blue: 0.3882352941, alpha: 1),"32":#colorLiteral(red: 0.9647058824, green: 0.4862745098, blue: 0.3725490196, alpha: 1),"64":#colorLiteral(red: 0.9647058824, green: 0.368627451, blue: 0.231372549, alpha: 1),"128":#colorLiteral(red: 0.9294117647, green: 0.8117647059, blue: 0.4470588235, alpha: 1),"256":#colorLiteral(red: 0.9294117647, green: 0.8, blue: 0.3803921569, alpha: 1),"512":#colorLiteral(red: 0.9294117647, green: 0.7843137255, blue: 0.3137254902, alpha: 1),"1024":#colorLiteral(red: 0.9294117647, green: 0.7725490196, blue: 0.2470588235, alpha: 1),"2048":#colorLiteral(red: 0.9294117647, green: 0.7607843137, blue: 0.1803921569, alpha: 1),"4096":#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1),"8192":#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),"16384":#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),"32768":#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    for i in 0..<numberOffRows {
        for j in 0..<numberOffRows {
            arrLabelGrid[i][j].backgroundColor = arrColor["\(arrDataGrid[i][j])"]
            arrLabelGrid[i][j].text = (arrDataGrid[i][j] == 0) ? "" : "\(arrDataGrid[i][j])"
            arrLabelGrid[i][j].textColor = (arrDataGrid[i][j] > 4) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.4666666667, green: 0.431372549, blue: 0.3960784314, alpha: 1)

            if arrDataGrid[i][j] > 9999 {
                arrLabelGrid[i][j].font = UIFont.boldSystemFont(ofSize: 17)
            }else if arrDataGrid[i][j] > 999 {
                arrLabelGrid[i][j].font = UIFont.boldSystemFont(ofSize: 21)
            }else{
                arrLabelGrid[i][j].font = UIFont.boldSystemFont(ofSize: 25)
            }
        }
    }
}
func initItem() {
    var arrData0:[[Int]] = []
    for i in 0..<numberOffRows {
        for j in 0..<numberOffRows {
            if arrDataGrid[i][j] == 0 {
                arrData0.append([i,j])
            }
        }
    }
    let randomInData0 = Int(arc4random_uniform(UInt32(arrData0.count)))
    arrDataGrid[arrData0[randomInData0][0]][arrData0[randomInData0][1]] = 2
}
func initGame(numberOffRows number: Int) {
    
    for i in arrLabelGrid {
        for j in i {
            j.layer.cornerRadius = 5
            j.clipsToBounds = true
        }
    }
    
    for i in 0..<number {
        arrDataGrid.append([])
        for _ in 0..<number {
            arrDataGrid[i].append(0)
        }
    }
//    arrDataGrid = [
//        [2,4,8,16],
//        [32,64,128,256],
//        [512,1024,2048,4096],
//        [4096,4096,4096,4096]
//    ]
    initItem()
    drawGrid()
}
func printGrid(arrGrid:[[Int]]) {
    for i in arrGrid {
        print(i)
    }
}
