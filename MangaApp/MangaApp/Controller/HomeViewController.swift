//
//  ViewController.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
import Alamofire

var mangaList:[Manga] = [Manga]()

class HomeViewController: UIViewController {
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    
    @IBOutlet weak var mangaCollectionView: UICollectionView!
    
    @IBOutlet weak var maskMenu: UIView!
    
    @IBOutlet weak var tableMenu: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mangaCollectionView.dataSource = self
        mangaCollectionView.delegate = self

        loadManga()
        
        //tableMenu.separatorInset = UIEdgeInsets.zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let flowLayout = mangaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize.width = (screenWidth - 40) / 3
            flowLayout.itemSize.height = (flowLayout.itemSize.width) * (195/110)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func loadManga(){
        self.startLoading()
        if let getManga = UserDefaults.standard.value(forKey:"allManga") as? Data {
            guard let getManga = try? PropertyListDecoder().decode(Array<Manga>.self, from: getManga) else {return}
            mangaList = getManga
            print(mangaList.count)
            mangaCollectionView.reloadData()
            self.stopLoading()
        }else{
            
            Alamofire.request("\(apiHost)list/0").responseJSON { (response) in
                guard let resultValue = response.result.value as? JSONData else {return}
                if let mangaListData = resultValue["manga"] as? [JSONData] {
                    for mangaData in mangaListData {
                        if let manga = Manga(data: mangaData){
                            mangaList.append(manga)
                        }
                    }
                    self.mangaCollectionView.reloadData()
                    self.stopLoading()
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(mangaList), forKey:"allManga")
                }
            }
        }
    }

    @IBAction func searchManga(_ sender: UIButton) {
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "mangaSearchVC") as? MangaSearchViewController else {return}
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @IBAction func maskViewGesture(_ sender: UITapGestureRecognizer) {
        showHideMenu()
    }
    
    @IBAction func showMenu(_ sender: UIButton) {
        showHideMenu()
    }
    
    func showHideMenu(){
        if constraint.constant == 0 {
            maskMenu.isHidden = true
            constraint.constant = -200
        }else{
            constraint.constant = 0
            maskMenu.isHidden = false
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! MangaCollectionViewCell
        
        cell.setUpCell(data: mangaList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? MangaDetailViewController else {return}
        detailVC.id = mangaList[indexPath.item].id
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}













