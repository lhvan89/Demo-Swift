//
//  MangaDetail.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import Foundation
struct MangaDetail {
    var author: String
    var shortChapterDetail:[ShortChapterDetail] = [ShortChapterDetail]()
    var chaptersLen:Int = 0
    var createdDate: Date = Date()
    var hits: Int = 0
    var imageLink: String = "http://lhvan.xyz/images/placeholder.jpg"
    var lastChapterDate: Date = Date()
    var title: String
    var categories:[String] = [String]()
    var description: String = "No info"
    var status: Int = 1
    
    init?(data: JSONData) {
        guard let author = data["author"] as? String else {return nil}
        guard let title = data["title"] as? String else {return nil}
        
        self.author = author
        self.title = title
        
        if let chaptersArr = data["chapters"] as? [Any], chaptersArr.count > 0 {
            for i in 0..<chaptersArr.count {
                guard let shortChapterDetailArr = chaptersArr[i] as? [Any] else { continue }
                
                if let shortChapterDetail = ShortChapterDetail(arr: shortChapterDetailArr) {
                    self.shortChapterDetail.append(shortChapterDetail)
                }
            }
        }
        guard let chaptersLen = data["chapters_len"] as? Int else {return}
        self.chaptersLen = chaptersLen
        
        if let createdDateTime = data["created"] as? TimeInterval {
            self.createdDate = Date(timeIntervalSince1970: createdDateTime)
        }
        
        guard let hits = data["hits"] as? Int else {return}
        self.hits = hits
        
        guard let description = data["description"] as? String else{return}
        self.description = description
        
        if let imgLink = data["image"] as? String {
            self.imageLink = "\(hostImgLink)\(imgLink)"
        }
        
        if let lastChapterDate = data["last_chapter_date"] as? TimeInterval {
            self.lastChapterDate = Date(timeIntervalSince1970: lastChapterDate)
        }
        
        guard let categories = data["categories"] as? [String] else {return}
        self.categories = categories
        
        guard let status = data["status"] as? Int else {return}
        self.status = status
    }
}














