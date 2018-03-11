//
//  HomeViewController.swift
//  Movie App
//
//  Created by lhvan on 10/29/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import UIKit
import Alamofire
import PageMenu

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    var pageMenu:CAPSPageMenu!
    let group = DispatchGroup()
    var topRatedMoveList:[Movie] = [Movie]()
    var latestMoveList:[Movie] = [Movie]()
    var upComingMoveList:[Movie] = [Movie]()
    var nowPlayingMoveList:[Movie] = [Movie]()
    var popularMoveList:[Movie] = [Movie]()
    var searchController:UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.pleaseWait()
        addSearchBar()
        NotificationCenter.default.addObserver(self, selector: #selector(moveToDetailVCBy(noti:)), name: NSNotification.Name(rawValue: "viewDetail") , object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isFirstLoad {
            self.containerView.pleaseWait()
            group.enter()
            MovieDataStore.share.getListMovie(page: page, type: TypeOfMovie.topRated.rawValue ) { (movieList) in
                if let `moveList` = movieList {
                    self.topRatedMoveList = moveList
                    self.group.leave()
                }
            }
            
            
            group.enter()
            MovieDataStore.share.getListMovie(page: page, type: TypeOfMovie.nowPlaying.rawValue) { (movieList) in
                if let `moveList` = movieList {
                    self.nowPlayingMoveList = moveList
                    self.group.leave()
                }
            }
            
            group.enter()
            MovieDataStore.share.getListMovie(page: page, type: TypeOfMovie.upComing.rawValue) { (movieList) in
                if let `moveList` = movieList {
                    self.upComingMoveList = moveList
                    self.group.leave()
                }
                
            }
            
            group.enter()
            MovieDataStore.share.getListMovie(page: page, type: TypeOfMovie.popular.rawValue) { (movieList) in
                if let `moveList` = movieList {
                    self.popularMoveList = moveList
                }
                self.group.leave()
            }
            let timed_out = group.wait(timeout: .now() + 60)
            if timed_out == .success {
                
            } else {
            }
            self.clearAllNotice()
            createPageMenu()
            isFirstLoad = false
        }
    }
    
    private func addSearchBar() {
        
        guard let searchResultsController = self.storyboard?.instantiateViewController(withIdentifier: SearchResultViewController.identifier) as? SearchResultViewController else { return }
        //        searchResultsController.delegate = self
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        /*
         Configure the search controller's search bar. For more information on
         how to configure search bars, see the "Search Bar" group under "Search".
         */
        searchController.searchBar.searchBarStyle   = .prominent
        searchController.searchBar.placeholder      = NSLocalizedString("Search", comment: "")
        searchController.searchBar.delegate         = searchResultsController
        
        // Include the search bar within the navigation bar.
        navigationItem.titleView = searchController.searchBar
        
        
        
        
        definesPresentationContext = true
        
    }
    
    func createViewControllerForPageMenu(titleType: MovieListTitle) -> MoviesViewController {
        let newVC = MoviesViewController.newVC()
        newVC.title = titleType.rawValue
        switch titleType {
        case .topRatedTitle:
            newVC.movieList = topRatedMoveList
            newVC.typeOfMovie = .topRated
        case .popularTitle:
            newVC.movieList = popularMoveList
            newVC.typeOfMovie = .popular
        case .nowPlayingTitle:
            newVC.movieList = nowPlayingMoveList
            newVC.typeOfMovie = .nowPlaying
            //        case .upComing:
        //            newVC.movieList = upComingMoveList
        default:
            newVC.movieList = upComingMoveList
            newVC.typeOfMovie = .upComing
        }
        
        return newVC
    }
    
    func createPageMenu() {
        let topRatedVC = createViewControllerForPageMenu(titleType: .topRatedTitle)
        
        let popularVC = createViewControllerForPageMenu(titleType: .popularTitle)
        
        let nowPlayingVC = createViewControllerForPageMenu(titleType: .nowPlayingTitle)
        
        let upComingVC = createViewControllerForPageMenu(titleType: .upComingTitle)
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor.orange),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]
        
        //        pageMenu = CAPSPageMenu(viewControllers: [topRatedVC, popularVC, nowPlayingVC, upComingVC], frame: CGRect(x: 0.0,y: 20 + (self.navigationController?.navigationBar.bounds.size.height)!, width: screenWidth,height: screenHeight - 65), pageMenuOptions: parameters)
        pageMenu = CAPSPageMenu(viewControllers: [topRatedVC, popularVC, nowPlayingVC, upComingVC], frame: containerView.bounds, pageMenuOptions: parameters)
        
        containerView.addSubview(pageMenu!.view)
        pageMenu.didMove(toParentViewController: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToDetailVCBy(noti: Notification) {
        guard let userInfo = noti.userInfo else {return}
        guard let movieId = userInfo["movieId"] as? Int else {return}
        let detailVC = MovieDetailViewController.newVC()
        detailVC.movieId = movieId
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
