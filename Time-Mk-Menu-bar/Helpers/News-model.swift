//
//  News-model.swift
//  Time-Mk-Menu-bar
//
//  Created by Matej Plavevski on 8/18/20.
//  Copyright © 2020 Matej Plavevski. All rights reserved.
//

import Foundation

/*
struct Response: Codable {
    var results: [NewsPiece]
}*/

struct NewsPiece {
    var title: String
    var description: String
    //var image: String
    var article_url: URL
}
