//
//  Extenstion.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func startLoading() {
        self.pleaseWait()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.clearAllNotice()
        self.view.isUserInteractionEnabled = true
    }
}

extension UIView {
    func startLoading() {
        self.pleaseWait()
        self.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.clearAllNotice()
        self.isUserInteractionEnabled = true
    }
}
