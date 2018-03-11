//
//  Manga.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import Foundation
import UIKit

struct Manga: Codable {
    var alias: String
    var category: [String] = [String]()
    var hits: Int = 0
    var id: String
    var image: String = "http://lhvan.xyz/images/placeholder.jpg"
    var lastChapterDate: Date = Date()
    var status: Int = 1 //1: Completed, 2: Ongoing
    var title: String
    init?(data: JSONData){

        guard let alias = data["a"] as? String else {return nil}
        guard let category = data["c"] as? [String] else {return nil}
        guard let hits = data["h"] as? Int else {return nil}
        guard let id = data["i"] as? String else {return nil}
        guard let status = data["s"] as? Int else {return nil}
        guard let title = data["t"] as? String else {return nil}

        self.alias = alias
        self.category = category
        self.hits = hits
        self.id = id
        self.status = status
        self.title = title
        
        if let lastChapterDate = data["l"] as? TimeInterval{
            self.lastChapterDate = Date(timeIntervalSince1970: lastChapterDate)
        }
        if let imageLink = data["im"] as? String {
            self.image = "\(hostImgLink)\(imageLink)"
        }
    }
}
