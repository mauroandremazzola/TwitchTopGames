//
//  Game+CoreDataClass.swift
//  
//
//  Created by Mauro André Barros Mazzola on 28/01/18.
//
//

import Foundation
import CoreData

public class Game: NSManagedObject, Decodable {
    
    var isFavorite : Bool?
    
    indirect enum CodingKeys : String, CodingKey {
        case viewers
        case game
    }
    
    //MARK - Decodable initilizer
    
    public required convenience init(from decoder: Decoder) throws {
        let dataManager = DataManager()

        guard let description = NSEntityDescription.entity(forEntityName: "Game", in: dataManager.context) else {
            fatalError("Failed to decode Game =/")
        }
        
        self.init(entity: description, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gameInfo = try container.decode(GameInfo.self, forKey: .game)
        id = gameInfo.id
        name = gameInfo.name
        viewers = try container.decode(Int32.self, forKey: .viewers)
        image = URL(string: gameInfo.box.large)
        setFavorite(game: self)
    }

    //MARK - privates
    
    private func setFavorite(game: Game) {
        let dataManager = DataManager()
        let fetchRequest = Game.fetchRequest() as NSFetchRequest<Game>
        fetchRequest.predicate = NSPredicate(format: "id = %ld", game.id)
        
        do {
            if let finded = try dataManager.context.fetch(fetchRequest).first {
                isFavorite = true
                finded.viewers = game.viewers
                dataManager.saveContext()
            } else {
                isFavorite = false
            }
        } catch {
            print("Faild fetch request Game: \(error)")
        }
    }
    
    //MARK - internal
    
    internal class func mock() -> Game {
        let dataManager = DataManager()
        guard let description = NSEntityDescription.entity(forEntityName: "Game", in: dataManager.context) else {
            fatalError("Failed to generate Game mock =/")
        }
        return Game(entity: description, insertInto: nil)
    }
}

//MARK -  helper structs

extension Game {
    
    struct GameImageURL: Decodable {
        var large :String
        var medium : String
        var small : String
        var template :String
    }
    
    struct GameInfo: Decodable {
        var name : String
        var id : Int32
        var box : GameImageURL
        
        enum CodingKeys : String, CodingKey {
            case name
            case id = "_id"
            case box
        }
    }
}

