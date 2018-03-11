//
//  MovieDetail.swift
//  Movie App
//
//  Created by lhvan on 11/2/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation

struct MovieDetail : MovieAppModel {
    var id: Int
    var title: String
    var hasVideo: Bool = false
    var release_date: String
    var original_title: String
    var original_language: String = "en"
    var imdb_id:String
    var vote_average: Double = 0
    var vote_count: Int = 0
    var popularity: Double = 0
    var poster_path: String = ""
    var backdrop_path: String = ""
    var adult: Bool = false
    var genres:[Genre] = [Genre]()
    var budget:Double = 0
    var revenue: Double = 0
    var overview:String = "Updating..."
    
    init?(jsonData: JSONData) {
        guard let id = jsonData["id"] as? Int else {return nil}
        guard let release_date = jsonData["release_date"] as? String else {return nil}
        guard let original_title = jsonData["original_title"] as? String else { return nil }
        guard let title = jsonData["title"] as? String else { return nil }
        guard let imdb_id = jsonData["imdb_id"] as? String else { return nil }
        
        self.id = id
        self.release_date = release_date
        self.original_title = original_title
        self.title = title
        self.imdb_id = imdb_id
        
        if let poster_path = jsonData["poster_path"] as? String, poster_path != "" {
            self.poster_path = "\(img_api)\(poster_size_key)\(poster_path)"
        }
        
        if let adult = jsonData["adult"] as? Bool {
            self.adult = adult
        }
        
        if let overview = jsonData["overview"] as? String {
            self.overview = overview
        }
        
        if let genreDataList = jsonData["genres"] as? [JSONData], genreDataList.count > 0 {
            for genreData in genreDataList {
                if let genre = Genre(jsonData: genreData) {
                    self.genres.append(genre)
                }
            }
        }
        
        if let backdrop_path = jsonData["backdrop_path"] as? String, backdrop_path != "" {
            self.backdrop_path = "\(img_api)\(backdrop_size_key)\(backdrop_path)"
        }
        
        if let original_language = jsonData["original_language"] as? String, original_language != "" {
            self.original_language = original_language
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
