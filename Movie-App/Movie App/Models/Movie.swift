//
//  Movie.swift
//  Movie App
//
//  Created by lhvan on 10/29/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation

struct Movie : MovieAppModel {
    var id:Int
    var poster_path:String = ""
    var adult:Bool = false
    var overview:String = "We don't have an overview translated in English. Help us expand our database by adding one."
    var release_date:String
    var genres:[Int] = [Int]()
    var original_title:String
    var original_language:String = "en"
    var title:String
    var backdrop_path:String = ""
    var popularity:Double = 0
    var vote_count:Int = 0
    var hasVideo:Bool = false
    var vote_average:Double = 0
    
    init?(jsonData: JSONData) {
        guard let id = jsonData["id"] as? Int else {return nil}
        guard let release_date = jsonData["release_date"] as? String else {return nil}
        guard let original_title = jsonData["original_title"] as? String else { return nil }
        guard let title = jsonData["title"] as? String else { return nil }
        
        self.id = id
        self.release_date = release_date
        self.original_title = original_title
        self.title = title
        
        if let poster_path = jsonData["poster_path"] as? String, poster_path != "" {
            self.poster_path = "\(img_api)\(poster_size_key)\(poster_path)"
        }
        
        if let adult = jsonData["adult"] as? Bool {
            self.adult = adult
        }
        
        if let overview = jsonData["overview"] as? String, !overview.isEmpty {
            self.overview = overview
        }
        
        if let genre_ids = jsonData["genre_ids"] as? [Int] {
            self.genres = genre_ids
        }
        
        if let backdrop_path = jsonData["backdrop_path"] as? String, backdrop_path != "" {
            self.backdrop_path = "\(img_api)\(backdrop_size_key)\(backdrop_path)"
        }
        
        if let popularity = jsonData["popularity"] as? Double {
            self.popularity = popularity
        }
        
        if let vote_count = jsonData["vote_count"] as? Int {
            self.vote_count = vote_count
        }
        
        if let hasVideo = jsonData["video"] as? Bool {
            self.hasVideo = hasVideo
        }
        
        if let vote_average = jsonData["vote_average"] as? Double {
            self.vote_average = vote_average
        }
    }
}
