//
//  Chapter.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import Foundation
struct ShortChapterDetail {
    
    var chapterNumber: Int
    var chapterName: String = ""
    var chapterId: String
    
    init?(arr: [Any]) {
        guard arr.count > 0 else {return nil}
        guard let chapterNumber = arr[0] as? Int else {return nil}
        guard let chapterId = arr[3] as? String else {return nil}
        self.chapterNumber = chapterNumber
        self.chapterId = chapterId
        
        if let chapterName = arr[2] as? String {
            self.chapterName = chapterName
        }
    }
}

struct ChapterImage {
    var chapterImageId: Int = 0
    var imgLink:String = "http://lhvan.xyz/images/placeholder.jpg"
    var height: Int = 0
    var width: Int = 0
    
    init?(arr: [Any]) {
        guard arr.count > 0 else {return nil}
        
        guard let chapterImageId = arr[0] as? Int else {return nil}
        guard let width = arr[2] as? Int else { return nil }
        guard let height = arr[3] as? Int else { return nil }
        
        self.width = width
        self.height = height
        
        self.chapterImageId = chapterImageId
        
        if let imgLink = arr[1] as? String {
            self.imgLink = "\(hostImgLink)\(imgLink)"
        }
    }
}
















