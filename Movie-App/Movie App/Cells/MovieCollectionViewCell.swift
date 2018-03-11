//
//  MovieCollectionViewCell.swift
//  Movie App
//
//  Created by lhvan on 11/1/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "movieCell"
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieVoteAverageLabel : UILabel!
    
    func setUpCell(movie: Movie) {
        
        movieVoteAverageLabel.text = movie.vote_average.convertToStringWithOneDecimal()
        movieNameLabel.text = movie.title
        
        if let url = URL(string: movie.backdrop_path) {
            movieImageView.kf.indicatorType = .activity
            movieImageView.kf.indicator?.startAnimatingView()
            movieImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder_movie_backdrop"), options: [.transition(.fade(0.25)), .backgroundDecode], progressBlock: nil, completionHandler: { (img, error, cache, url) in
                if let img = img {
                    DispatchQueue.main.async(execute: {
                        self.movieImageView.image = img
                    })
                }else {
                    DispatchQueue.main.async(execute: {
                        self.movieImageView.image = #imageLiteral(resourceName: "updating_movie_backdrop")
                    })
                }
            })
        } else {
            movieImageView.image = #imageLiteral(resourceName: "updating_movie_backdrop")
        }
    }
}
