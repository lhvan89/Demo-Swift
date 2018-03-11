//
//  MovieListViewController.swift
//  Movie App
//
//  Created by lhvan on 10/31/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListViewController: BaseViewController {
    
    static let identifier = "movieListVC"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var movieList:[Movie] = [Movie]()
    var typeOfMovie:TypeOfMovie?
    var castId:Int?
    var castName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.addSubview(refeshing)
        //        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 65, right: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            
            if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                flowLayout.itemSize.width = (screenWidth - 20)
                flowLayout.itemSize.height = (screenHeight - 5) / 2.5
            }
            
            if let _ = self.castId {
                self.pleaseWait()
                self.title = castName
                dataForFirstPage()
            }
            
            
            
            isFirstLoad = false
        }
    }
    
    class func newVC() -> MovieListViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! MovieListViewController
    }
    
    func dataForFirstPage() {
        page = 1
        isLoading = true
        if let typeOfMovie = typeOfMovie {
            MovieDataStore.share.getListMovie(page: page, type: typeOfMovie.rawValue) { (movieList) in
                if let movieList = movieList {
                    self.movieList = movieList
                    DispatchQueue.main.async(execute: { [weak self] in
                        guard let `self` = self else {return}
                        self.collectionView.reloadData()
                    })
                }
                self.isLoading = false
            }
        }else {
            guard let castId = self.castId else { return }
            MovieDataStore.share.getMovieListBy(castId: castId, page: page, response: { (movies) in
                if let movies = movies {
                    self.movieList = movies
                    DispatchQueue.main.async(execute: { [weak self] in
                        guard let `self` = self else {return}
                        self.collectionView.reloadData()
                    })
                    
                }
                self.isLoading = false
                self.clearAllNotice()
            })
        }
    }
    
    func dataForNextPage() {
        Thread.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(loadNextPage), with: self, afterDelay: 0.2)
    }
    
    func loadNextPage() {
        page += 1
        isLoading = true
        if let typeOfMovie = typeOfMovie {
            MovieDataStore.share.getListMovie(page: page, type: typeOfMovie.rawValue) { (movieList) in
                if let movieList = movieList {
                    self.movieList += movieList
                    DispatchQueue.main.async(execute: { [weak self] in
                        guard let `self` = self else {return}
                        self.collectionView.reloadData()
                    })
                }else {
                    self.page -= 1
                }
                self.isLoading = false
            }
        }else {
            guard let castId = self.castId else { return }
            MovieDataStore.share.getMovieListBy(castId: castId, page: page, response: { (movies) in
                if let movies = movies {
                    self.movieList += movies
                    DispatchQueue.main.async(execute: { [weak self] in
                        guard let `self` = self else {return}
                        self.collectionView.reloadData()
                    })
                }else{
                    self.page -= 1
                }
                self.isLoading = false
            })
        }
    }
    
}

extension MovieListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        let movie = movieList[indexPath.item]
        cell.setUpCell(movie: movie)
        
        return cell
    }
}

extension MovieListViewController : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if isLoading { return }
        
        if refeshing.isRefreshing {
            dataForFirstPage()
            refeshing.endRefreshing()
        }
        
        let offSetY = scrollView.contentOffset.y
        let heightOfContent = scrollView.contentSize.height
        
        if heightOfContent - offSetY - scrollView.bounds.size.height <= 1 {
            dataForNextPage()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = movieList[indexPath.item]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewDetail" ), object: nil, userInfo: ["movieId": movie.id])
        
    }
}
