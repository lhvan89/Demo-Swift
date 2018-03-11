//
//  MovieDetailListTableViewCell.swift
//  Movie App
//
//  Created by lhvan on 11/4/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit

protocol MovieDetailListTableViewCellDelegate : class {
    func moveToMoveListVCBy(castId: Int, castName: String)
}

class MovieDetailListTableViewCell: UITableViewCell {

    static let identifier = "collectionCell"
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var movieList:[Movie] = [Movie]()
    lazy var castList:[Cast] = [Cast]()
    weak var delegate : MovieDetailListTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MovieDetailListTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieList.count > 0 {
            return movieList.count
        }else {
            return castList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailCollectionViewCell.identifier , for: indexPath) as! MovieDetailCollectionViewCell
        
        if movieList.count > 0 {
            let movie = movieList[indexPath.item]
            cell.setUpCell(movie: movie)
        }else {
            let cast = castList[indexPath.item]
            cell.setUpCell(cast: cast)
        }
        
        return cell
    }
}

extension MovieDetailListTableViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if movieList.count > 0 {
            let movie = movieList[indexPath.item]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewDetail" ), object: nil, userInfo: ["movieId": movie.id])
        }else if castList.count > 0 {
            let cast = castList[indexPath.item]
            delegate?.moveToMoveListVCBy(castId: cast.id, castName: cast.name)
        }
    }
}
