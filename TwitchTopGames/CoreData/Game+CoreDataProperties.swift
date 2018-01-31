//
//  Game+CoreDataProperties.swift
//  
//
//  Created by Mauro André Barros Mazzola on 29/01/18.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var id: Int32
    @NSManaged public var image: URL?
    @NSManaged public var name: String?
    @NSManaged public var viewers: Int32

}
