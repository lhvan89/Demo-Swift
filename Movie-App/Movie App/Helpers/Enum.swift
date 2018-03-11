//
//  MovieListType.swift
//  Movie App
//
//  Created by lhvan on 10/31/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation

enum MovieListTitle : String {
    case topRatedTitle = "Top Rated"
    case popularTitle = "Popular"
    case nowPlayingTitle = "Now Playing"
    case upComingTitle = "Upcoming"
}

enum TypeOfMovie : String {
    case topRated = "top_rated"
    case upComing = "upcoming"
    case nowPlaying = "now_playing"
    case popular = "popular"
}

enum TypeOfListMovieForCollectionViewInDetailTableViewCell {
    case CAST
    case RECOMMENDATION
    case SIMILAR
}
