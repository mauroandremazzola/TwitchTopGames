//
//  Game+CoreDataProperties.swift
//  
//
//  Created by Mauro André Barros Mazzola on 28/01/18.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int16
    @NSManaged public var image: URL?
    @NSManaged public var viewers: Int16

}
