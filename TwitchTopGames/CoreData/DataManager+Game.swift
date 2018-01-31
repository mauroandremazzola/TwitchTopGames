//
//  DataManager+Game.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 30/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
    
    func addToFavorites(_ game: Game) {
        
        guard let description = NSEntityDescription.entity(forEntityName: "Game", in: context) else {
            fatalError("Failed to decode Game =/")
        }
        
        let favorite = Game(entity: description, insertInto: context)
        favorite.name = game.name
        favorite.id = game.id
        favorite.image = game.image
        favorite.viewers = game.viewers
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        saveContext()
    }
    
    func removeFromFavorite(game: Game) {
        context.delete(game)
        saveContext()
    }
    
    func findGame(id: Int32) -> Game? {
        let fetchRequest = Game.fetchRequest() as NSFetchRequest<Game>
        fetchRequest.predicate = NSPredicate(format: "id = %ld", id)
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Faild fetch request Game: \(error)")
            return nil
        }
    }
    
    func loadFavorites() -> [Game] {
        let fetchRequest = Game.fetchRequest() as NSFetchRequest<Game>
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "viewers", ascending: false)]
        do {
            let games = try context.fetch(fetchRequest)
            games.forEach{ $0.isFavorite = true }
            return games
        } catch {
            print("Faild fetch request Game: \(error)")
            return []
        }
    }
    
}
