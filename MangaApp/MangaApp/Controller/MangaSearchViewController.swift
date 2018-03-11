//
//  SearchViewController.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit


class MangaSearchViewController: UIViewController, UITextFieldDelegate {
    
    var searchResult:[Manga] = [Manga]()
    
    @IBOutlet weak var searchKey: UITextField!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        self.searchKey.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: searchKey.frame.height))
        searchKey.leftView = paddingView
        searchKey.leftViewMode = UITextFieldViewMode.always
    }
    
    @IBAction func searchKeyAction(_ sender: UITextField) {
        searchManga()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let flowLayout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize.width = (screenWidth - 40) / 3
            flowLayout.itemSize.height = (flowLayout.itemSize.width) * (195/110)
        }
    }
    
    func searchManga(){
        self.searchResult.removeAll()
        for i in mangaList {
            guard let keyTitle = searchKey.text else {return}
            let title:String = i.title
            if title.lowercased().contains(keyTitle.lowercased()) {
                self.searchResult.append(i)
            }
        }
        searchCollectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension MangaSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        
        cell.setUpCell(data: searchResult[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? MangaDetailViewController else {return}
        detailVC.id = searchResult[indexPath.item].id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
