//
//  GenreDataStore.swift
//  Movie App
//
//  Created by lhvan on 10/29/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation
import Alamofire


class GenreDataStore {
    static var share = GenreDataStore()
    var genreList:[Genre] = [Genre]()
    
    private var isLoading = false
    
    func loadGenreList() {
        if isLoading {return}
        isLoading = true
        
        Alamofire.request("\(v3_api)genre/movie/list?api_key=\(v3_api_key)&language=\(lg_us)", method: .get)
            .responseJSON { (response) in
                if let resultData = response.result.value as? JSONData {
                    if let genresData = resultData["genres"] as? [JSONData], genresData.count > 0 {
                        for genreData in genresData {
                            if let genre = Genre(jsonData: genreData) {
                                self.genreList.append(genre)
                            }
                        }
                    }
                }
                self.isLoading = false
        }
        
    }
    
    func getDictionFromGenreList() -> [Int:String] {
        var dicGenre:[Int:String] = [Int:String]()
        
        if genreList.count <= 0 {return dicGenre}
        
        for genre in genreList {
            dicGenre[genre.id] = genre.name
        }
        return dicGenre
    }
    
    
}
