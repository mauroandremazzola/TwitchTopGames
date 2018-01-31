//
//  NotificationName+Game.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 30/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import Foundation

enum GameKeys: String {
    case id
}

extension Notification.Name {
    
    static let addToFavorites = Notification.Name("addToFavorites")
    static let removeFromFavorites = Notification.Name("removeFromFavorites")

}
