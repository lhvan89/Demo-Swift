//
//  MovieDetailCollectionViewCell.swift
//  Movie App
//
//  Created by lhvan on 11/4/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailCollectionViewCell: UICollectionViewCell {
    static let identifier = "infoCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setUpCell(cast: Cast) {
        nameLabel.text = cast.name
        guard let imgUrl = URL(string: cast.profile_path) else {
            self.imageView.image = #imageLiteral(resourceName: "updating_movie_poster")
            return
        }
        imageView.kf.indicatorType = .activity
        imageView.kf.indicator?.startAnimatingView()
        imageView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "placeholder_movie_poster"), options: [.transition(.fade(0.25)), .backgroundDecode]) { (img, error, cache, url) in
            if let img = img {
                DispatchQueue.main.async(execute: { 
                    self.imageView.image = img
                    self.imageView.kf.indicator?.stopAnimatingView()
                })
            }else {
                DispatchQueue.main.async(execute: {
                    self.imageView.image = #imageLiteral(resourceName: "updating_movie_poster")
                    self.imageView.kf.indicator?.stopAnimatingView()
                })
            }
            
        }
    }
    
    func setUpCell(movie: Movie) {
        nameLabel.text = movie.title
        guard let imgUrl = URL(string: movie.poster_path) else {
            imageView.image = #imageLiteral(resourceName: "updating_movie_poster")
            return
        }
        imageView.kf.indicatorType = .activity
        imageView.kf.indicator?.startAnimatingView()
        imageView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "placeholder_movie_poster"), options: [.transition(.fade(0.25)), .backgroundDecode]) { (img, error, cache, url) in
            if let img = img {
                DispatchQueue.main.async(execute: {
                    self.imageView.image = img
                    self.imageView.kf.indicator?.stopAnimatingView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.imageView.image = #imageLiteral(resourceName: "updating_movie_poster")
                    self.imageView.kf.indicator?.stopAnimatingView()
                })
            }
        }
    }
}
