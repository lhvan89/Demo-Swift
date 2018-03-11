//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by lhvan on 3/7/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var wrapperContentView: UIView!
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    @IBOutlet weak var wrapperVoteAvgView: UIView!
    
    @IBOutlet weak var movieVoteAvgLabel: UILabel!
    
    @IBOutlet weak var moreOutletButton: UIButton!
    
    @IBOutlet weak var movieGenresLabel: UILabel!
    
    @IBOutlet weak var movieReviewLabel: UILabel!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var heightOfWrapperImageView: NSLayoutConstraint!
    override func layoutSubviews() {
        moviePosterImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        moviePosterImageView.layer.shadowColor = UIColor.init(white: 0, alpha: 0.32).cgColor
        moviePosterImageView.layer.shadowRadius = 3
        moviePosterImageView.layer.cornerRadius = 3
        moviePosterImageView.layer.shadowOpacity = 0.5
        moviePosterImageView.layer.shadowPath = UIBezierPath(rect: moviePosterImageView.bounds ).cgPath
        moviePosterImageView.layer.shouldRasterize = true
        moviePosterImageView.layer.rasterizationScale = UIScreen.main.scale
        
        wrapperVoteAvgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        wrapperVoteAvgView.layer.shadowColor = UIColor(red: 1, green: 205/255.0, blue: 0, alpha: 0.52).cgColor
        wrapperVoteAvgView.layer.shadowRadius = 15
        wrapperVoteAvgView.layer.cornerRadius = 15
        wrapperVoteAvgView.layer.shadowOpacity = 0.5
        wrapperVoteAvgView.layer.shadowPath = UIBezierPath(rect: wrapperVoteAvgView.bounds ).cgPath
        wrapperVoteAvgView.layer.shouldRasterize = true
        wrapperVoteAvgView.layer.rasterizationScale = UIScreen.main.scale
        
        wrapperContentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        wrapperContentView.layer.shadowColor = UIColor.init(white: 0, alpha: 0.32).cgColor
        wrapperContentView.layer.shadowRadius = 4
        wrapperContentView.layer.cornerRadius = 4
        wrapperContentView.layer.shadowOpacity = 0.5
        wrapperContentView.layer.shadowPath = UIBezierPath(rect: wrapperContentView.bounds ).cgPath
        wrapperContentView.layer.shouldRasterize = true
        wrapperContentView.layer.rasterizationScale = UIScreen.main.scale
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
