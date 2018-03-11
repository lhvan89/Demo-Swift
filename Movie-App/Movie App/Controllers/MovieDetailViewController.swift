//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by lhvan on 11/2/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit
import youtube_parser
import AVFoundation
import AVKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var videoWraperView: UIView!
    @IBOutlet weak var tableView: UITableView!
    static let identifier = "movieDetailVC"
    var isFirstLoad = true
    let group = DispatchGroup()
    var movie:MovieDetail?
    var videos:[Video] = [Video]()
    var recommendMovies:[Movie] = [Movie]()
    var similarMovies:[Movie] = [Movie]()
    var casts:[Cast] = [Cast]()
    let avController = AVPlayerViewController()
    var isLogined:Int?
    class func newVC() -> MovieDetailViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! MovieDetailViewController
    }
    
    var movieId:Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.pleaseWait()
        
        NotificationCenter.default.addObserver(self, selector: #selector(continueAction(notification:)), name: NSNotification.Name(rawValue: "continueAction"), object: nil)
    }
    
    func continueAction(notification : Notification) {
        if let userInfo = notification.userInfo as? [String:Any] {
            if let videoId = userInfo["videoId"] as? Int {
                isLogined = 1
                addWatchList(videoId: videoId)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLoad {
            group.enter()
            MovieDataStore.share.movieDetail(id: movieId, response: { (movieDetail) in
                if let movieDetail = movieDetail {
                    self.movie = movieDetail
                }
                self.group.leave()
            })
            
            group.enter()
            MovieDataStore.share.getVideosByMovieId(id: movieId, response: { (videos) in
                if let videos = videos, videos.count > 0 {
                    self.videos = videos
                    for video in videos {
                        
                        if video.type != .Trailer && video.size != 720 && video.site != "YouTube" {continue}
                        
                        guard let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(video.key)") else {continue}
                        Youtube.h264videosWithYoutubeURL(youtubeURL, completion: { (info, error) in
                            guard let urlStr = info?["url"] as? String else {return}
                            guard let videoURL = URL(string: urlStr) else {return}
                            
                            let avPlayerView = AVPlayerLayer(player: AVPlayer(url: videoURL))
                            avPlayerView.frame = self.videoWraperView.frame
                            self.avController.view.frame = self.videoWraperView.frame
                            self.avController.allowsPictureInPicturePlayback = false
                            self.avController.player = avPlayerView.player
                            self.avController.delegate = self
                            self.videoWraperView.addSubview(self.avController.view)
                        })
                    }
                }
                self.group.leave()
            })
            
            group.enter()
            MovieDataStore.share.getCastListBy(movieId: movieId, page: 1, response: { (castList) in
                if let castList = castList {
                    self.casts = castList
                }
                self.group.leave()
            })
            
            group.enter()
            MovieDataStore.share.getRecommendMoviesBy(movieId: movieId, page: 1, response: { (movies) in
                if let movies = movies {
                    self.recommendMovies = movies
                }
                self.group.leave()
            })
            
            group.enter()
            MovieDataStore.share.getSimilarMoviesBy(movieId: movieId, page: 1, response: { (movies) in
                if let movies = movies {
                    self.similarMovies = movies
                }
                
                self.group.leave()
            })
            
            let resultGroupWait = group.wait(timeout: DispatchTime.now() + 30)
            if resultGroupWait == .success {
                self.tableView.reloadData()
            }else {
                print("time out")
            }
            self.clearAllNotice()
            isFirstLoad = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func checkListMovies(cell: MovieDetailListTableViewCell, movieList: [Any]) {
        if movieList.count == 0  {
            cell.noResultView.isHidden = false
            cell.collectionView.isHidden = true
        }else {
            cell.noResultView.isHidden = true
            cell.collectionView.isHidden = false
        }
    }
    
}

extension MovieDetailViewController : AVPlayerViewControllerDelegate {
    func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        playerViewController.player?.play()
    }
    
    func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        playerViewController.player?.pause()
    }
    
}

extension MovieDetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailTableViewCell.identifier, for: indexPath) as! MovieDetailTableViewCell
            guard let movie = self.movie else { return cell }
            cell.setUpCell(movie: movie)
            cell.movie = movie
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailListTableViewCell.identifier, for: indexPath) as! MovieDetailListTableViewCell
            
            checkListMovies(cell: cell, movieList: casts)
            
            cell.castList = casts
            cell.delegate = self
            cell.collectionView.reloadData()
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailListTableViewCell.identifier, for: indexPath) as! MovieDetailListTableViewCell
            checkListMovies(cell: cell, movieList: recommendMovies)
            
            cell.movieList = recommendMovies
            cell.collectionView.reloadData()
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailListTableViewCell.identifier, for: indexPath) as! MovieDetailListTableViewCell
            
            checkListMovies(cell: cell, movieList: similarMovies)
            cell.movieList = similarMovies
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Cast"
        case 2:
            return "Recommendations"
        case 3:
            return "Similar"
        default:
            return nil
        }
    }
}

extension MovieDetailViewController : MovieDetailListTableViewCellDelegate {
    func moveToMoveListVCBy(castId: Int, castName: String) {
        let movieListVC = MoviesViewController.newVC()
        movieListVC.castId = castId
        movieListVC.castName = castName
        self.navigationController?.pushViewController(movieListVC, animated: true)
    }
}

extension MovieDetailViewController : MovieDetailTableViewCellDelegate {
    
    func addWatchList(videoId: Int) {
        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int {
            // Goi API add watchlist
        }else {
            // Gọi Màn hình login/register -> Quay lại màn hình này -> Add WatchList lại
            if isLogined == 1 {
                print("Yup")
            }else {
                let loginVC = LoginViewController.newVC()
                let param = [
                    "videoId" : videoId
                    // FromViewController
                    ] as [String:Any]
                loginVC.params = param
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
}

