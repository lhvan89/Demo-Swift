//
//  MangaDetailViewController.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class MangaDetailViewController: UIViewController {
    
    var id:String!
    var mangaDetail:MangaDetail?
    
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var chaptersList: UITableView!
    @IBOutlet weak var mangaImageView: UIImageView!
    @IBOutlet weak var mangaTitleLabel: UILabel!
    @IBOutlet weak var mangaAuthorLabel: UILabel!
    @IBOutlet weak var mangaStatusLabel: UILabel!
    @IBOutlet weak var mangaChaptersLabel: UILabel!
    @IBOutlet weak var mangaCreatedDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.id = "5372389645b9ef5a0b1d20d8"
        chaptersList.dataSource = self
        chaptersList.delegate = self
        
        placeholderView.isHidden = true
        self.startLoading()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func setUpScreen(){
        guard let mangaDetail = self.mangaDetail  else {return}
        mangaTitleLabel.text = mangaDetail.title
        mangaAuthorLabel.text = mangaDetail.author
        mangaStatusLabel.text = mangaDetail.status == 1 ? "Completed" : "Ongoing"
        mangaChaptersLabel.text = "\(mangaDetail.chaptersLen) chapters"
        mangaCreatedDateLabel.text = formatDateToString(date: mangaDetail.createdDate)
        
        guard let imgUrl = URL(string: mangaDetail.imageLink) else {return}
        mangaImageView.kf.setImage(with: imgUrl)
    }
    
    func loadData(){
        guard let id = self.id else {return}
        print(id)
        self.startLoading()
        Alamofire.request("\(apiHost)manga/\(id)/")
            .responseJSON { (response) in
            if let data = response.result.value as? JSONData {
                if let mangaDetail = MangaDetail(data: data) {
                    self.title = mangaDetail.title
                    self.mangaDetail = mangaDetail
                    self.setUpScreen()
                    self.chaptersList.reloadData()
                    self.stopLoading()
                    self.placeholderView.isHidden = false
                }
            }
        }
    }
}

extension MangaDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaDetail != nil ? mangaDetail!.shortChapterDetail.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath) as! MangaDetailTableViewCell
        guard let mangaDetail = self.mangaDetail else { return cell }
        if mangaDetail.shortChapterDetail.count <= 0 || mangaDetail.shortChapterDetail.count < indexPath.row {return cell}
        let shortDetail = mangaDetail.shortChapterDetail[indexPath.row]
        
        cell.setUpCell(shortChapterDetail: shortDetail)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortChapter = mangaDetail?.shortChapterDetail[indexPath.row]
        let vc = MangaChapterHolderVC.newVC(data: shortChapter!)
        
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}








