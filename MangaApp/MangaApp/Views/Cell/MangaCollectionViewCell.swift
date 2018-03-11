//
//  MangaCollectionViewCell.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
import Kingfisher

class MangaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mangaImageView: UIImageView!
    
    @IBOutlet weak var mangaTitleLabel: UILabel!
    
    func setUpCell(data: Manga){
        mangaTitleLabel.text = data.title
        
        mangaImageView.kf.indicatorType = .activity
        mangaImageView.kf.indicator?.startAnimatingView()
        
        if let imgURL = URL(string: data.image) {
            mangaImageView.kf.setImage(with: imgURL, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (img, error, type, url) in
                self.mangaImageView.kf.indicator?.stopAnimatingView()
            })
        }
    }
    
}
