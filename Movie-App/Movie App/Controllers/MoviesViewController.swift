//
//  MoviesViewController.swift
//  Movie App
//
//  Created by lhvan on 11/17/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit

class MoviesViewController: BaseViewController {

    static let identifier = "moviesVC"
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movieList:[Movie] = [Movie]()
    var typeOfMovie:TypeOfMovie?
    var castId:Int?
    var castName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(refeshing)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 65, right: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            
            if let _ = self.castId {
                self.pleaseWait()
                self.title = castName
                dataForFirstPage()
            }
            
            
            
            isFirstLoad = false
        }
    }
    
    class func newVC() -> MoviesViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! MoviesViewController
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
                        self.tableView.reloadData()
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
                        self.tableView.reloadData()
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
                        self.tableView.reloadData()
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
                        self.tableView.reloadData()
                    })
                }else{
                    self.page -= 1
                }
                self.isLoading = false
            })
        }
    }

}

extension MoviesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        let movie = movieList[indexPath.row]
        
        cell.setUpCell(movie: movie)
        
        return cell
    }
}

extension MoviesViewController : UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movieList[indexPath.item]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewDetail" ), object: nil, userInfo: ["movieId": movie.id])
    }
}

