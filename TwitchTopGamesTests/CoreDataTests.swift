//
//  CoreDataTests.swift
//  TwitchTopGamesTests
//
//  Created by Mauro André Barros Mazzola on 31/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import XCTest
@testable import TwitchTopGames

class CoreDataTests: XCTestCase {
    
    var gameTestOne : Game {
        get {
            let game = Game.mock()
            game.id = 1
            game.name = "game test 1"
            return game
        }
    }
    
    var gameTestTwo : Game {
        get {
            let game = Game.mock()
            game.id = 2
            game.name = "game test 2"
            return game
        }
    }
        
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadFavorites() {
        let dataManager = DataManager()
        dataManager.addToFavorites(gameTestOne)
        let games = dataManager.loadFavorites()
        XCTAssert(games.count >= 0, "Bug: DataManager+Game - loadFavorites() ")
        dataManager.removeFromFavorite(game: gameTestOne)
    }
    
    func testRemoveFromFavorite() {
        let dataManager = DataManager()
        dataManager.addToFavorites(gameTestOne)
        dataManager.removeFromFavorite(game: gameTestOne)
        let games = dataManager.loadFavorites()
        XCTAssert(!games.contains(where: { $0.id == gameTestOne.id }), "Bug: DataManager+Game - removeFromFavorite() ")
    }
    
    func testFindGame() {
        let dataManager = DataManager()
        dataManager.addToFavorites(gameTestOne)
        let finded = dataManager.findGame(id: gameTestOne.id)
        XCTAssert(gameTestOne.id == finded?.id, "Bug: DataManager+Game - findGame(id: Int32) ")
        dataManager.removeFromFavorite(game: gameTestOne)
    }
    
    func testGamesMustUniqueInFavorites() {
        let dataManager = DataManager()
        dataManager.addToFavorites(gameTestOne)
        dataManager.addToFavorites(gameTestOne)
        let games = dataManager.loadFavorites()
        XCTAssert(games.filter({ $0.id == gameTestOne.id }).count == 1, "Bug: DataManager+Game - addToFavorites() ")
        dataManager.removeFromFavorite(game: gameTestOne)
    }
    
}
