//
//  Cast.swift
//  Movie App
//
//  Created by lhvan on 11/4/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation

/*
 "cast_id": 14,
 "character": "Dr. Bruner",
 "credit_id": "564c6cad9251414dd1006bdd",
 "id": 357551,
 "name": "Amy Landecker",
 "order": 15,
 "profile_path": "/ZDwDDrGYkm3isAqwH10t2i353z.jpg"
*/
struct Cast {
    var id: Int
    var character:String
    var credit_id:String
    var name:String
    var profile_path:String = ""
    
    init?(jsonData: JSONData) {
        guard let id = jsonData["id"] as? Int else {return nil}
        guard let character = jsonData["character"] as? String else { return nil }
        guard let credit_id = jsonData["credit_id"] as? String else { return nil }
        guard let name = jsonData["name"] as? String else { return nil }
        
        self.id = id
        self.character = character
        self.credit_id = credit_id
        self.name = name
        
        if let profile_path = jsonData["profile_path"] as? String, !profile_path.isEmpty {
            self.profile_path = "\(img_api)\(profile_size_key)\(profile_path)"
        }
    }
}
