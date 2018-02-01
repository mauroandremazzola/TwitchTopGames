//
//  TwitchAPI.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 26/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit

enum GameAPI {
    
    case getTopGames(offset: Int, limit: Int)
    
    func requestConfig() -> RequestConfig {
        switch self {
        case .getTopGames(let offset, let limit):
            let parameters : [String : Any]  = ["offset" : offset, "limit" : limit]
            return RequestConfig(url: TwitchAPI.endpoint, method: .get, parameters: parameters, headers: TwitchAPI.headers)
        }
    }
}

class TwitchAPI: NSObject {
    
    private static let clientID = ""
    static let endpoint = "https://api.twitch.tv/kraken/games/top"
    
    static let headers : [String : String] = [
        "Accept": "application/json",
        "Client-ID": TwitchAPI.clientID
    ]
    
}
