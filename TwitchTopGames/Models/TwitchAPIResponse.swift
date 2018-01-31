//
//  TwitchAPIResponse.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 29/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import Foundation

struct TwitchAPIResponse: Decodable {
    
    struct APIResponseLink: Codable {
        var current : String
        var next : String
        
        enum CodingKeys : String, CodingKey {
            case current = "self"
            case next
        }
    }
    
    var total : Int
    var links : APIResponseLink?
    var games : [Game]
    
    enum CodingKeys : String, CodingKey {
        case total = "_total"
        case links = "_links"
        case games = "top"
    }
    
}
