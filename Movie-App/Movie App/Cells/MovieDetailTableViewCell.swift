//
//  MovieDetailTableViewCell.swift
//  Movie App
//
//  Created by lhvan on 11/4/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit

protocol MovieDetailTableViewCellDelegate : class {
    func addWatchList(videoId: Int)
}

class MovieDetailTableViewCell: UITableViewCell {
    static let identifier = "detailCell"
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var voteAvarageLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    
    @IBOutlet weak var movieRevenueLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieBudgetLabel: UILabel!
    @IBOutlet weak var moviePopularityLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    weak var delegate: MovieDetailTableViewCellDelegate?
    
    var movie: MovieDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(movie: MovieDetail) {
        voteAvarageLabel.text = movie.vote_average.convertToStringWithOneDecimal()
        moviePopularityLabel.text = movie.popularity.convertToStringWithOneDecimal()
        movieTitleLabel.text = movie.title
        movieBudgetLabel.text = movie.budget.convertToStringWithOneDecimal()
        movieRevenueLabel.text = movie.revenue.convertToStringWithOneDecimal()
        movieReleaseDateLabel.text = movie.release_date
        var genreNameList:[String] = [String]()
        for genre in movie.genres {
            genreNameList.append(genre.name)
        }
        movieGenresLabel.text = genreNameList.joined(separator: ", ")
        guard let imgUrl = URL(string: movie.poster_path) else {
            self.movieImageView.image = #imageLiteral(resourceName: "updating_movie_poster")
            return
        }
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.indicator?.startAnimatingView()
        movieImageView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "placeholder_movie_poster"), options: [.transition(.fade(0.25)), .backgroundDecode]) { (img, error, cache, url) in
            if let img = img {
                DispatchQueue.main.async(execute: {
                    self.movieImageView.image = img
                    self.movieImageView.kf.indicator?.stopAnimatingView()
                })
            }else {
                DispatchQueue.main.async(execute: {
                    self.movieImageView.image = #imageLiteral(resourceName: "updating_movie_poster")
                    self.movieImageView.kf.indicator?.stopAnimatingView()
                })
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addWatchListActionButton(_ sender: AnyObject) {
        Thread.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(addWatchList), with: self, afterDelay: 0.2)
    }
    
    func addWatchList() {
        guard let movie = self.movie else { return }
        delegate?.addWatchList(videoId: movie.id)
    }
}
