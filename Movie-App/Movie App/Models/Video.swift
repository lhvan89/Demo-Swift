//
//  Video.swift
//  Movie App
//
//  Created by lhvan on 11/3/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation

enum VideoType : String {
    case Trailer = "Trailer"
    case Teaser = "Teaser"
    case Featurette = "Featurette"
}


struct Video {
    var id:String
    var key: String
    var name: String = "Trailer 1"
    var size:Int = 720
    var site:String = ""
    var type : VideoType = .Trailer
    
    init?(jsonData: JSONData) {
        guard let id = jsonData["id"] as? String else { return nil }
        guard let key = jsonData["key"] as? String else { return nil }
        
        self.id = id
        self.key = key
        
        if let name = jsonData["name"] as? String{
            self.name = name
        }
        
        if let size = jsonData["size"] as? Int {
            self.size = size
        }
        
        if let site = jsonData["site"] as? String, !site.isEmpty {
            self.site = site
        }
        
        if let type = jsonData["type"] as? String {
            switch type {
            case VideoType.Teaser.rawValue:
                self.type = .Trailer
            case VideoType.Featurette.rawValue:
                self.type = .Featurette
            default:
                self.type = .Trailer
            }
        }
        
    }
}
