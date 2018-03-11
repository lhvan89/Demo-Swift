//
//  MovieAppModel.swift
//  Movie App
//
//  Created by lhvan on 11/2/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation

protocol MovieAppModel {
    var id:Int { get }
    var title:String { get set }
    var poster_path: String { get set }
    var backdrop_path : String { get set }
    var original_title: String { get }
    var original_language : String { get }
    var hasVideo : Bool { get set }
    var release_date : String { get set }
    var vote_average : Double { get set }
    var vote_count : Int { get set }
    var popularity : Double { get set }
    var adult : Bool { get set }
    
    init?(jsonData: JSONData)
}
