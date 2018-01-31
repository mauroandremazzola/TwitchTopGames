//
//  TwitchTopGamesTests.swift
//  TwitchTopGamesTests
//
//  Created by Mauro André Barros Mazzola on 26/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import XCTest
@testable import TwitchTopGames

class TwitchTopGamesTests: XCTestCase {
    
    var topController : TopGamesViewController?
    var favoritesController : FavoritesViewController?
    var detailController : DetailViewController?
    
    var game : Game {
        get {
            let game = Game.mock()
            game.id = 1
            game.name = "game test 1"
            return game
        }
    }
    
    var gameTwo : Game {
        get {
            let game = Game.mock()
            game.id = 2
            game.name = "game test 2"
            return game
        }
    }

    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        topController = storyboard.instantiateViewController(withIdentifier: "TopGamesViewController") as? TopGamesViewController
        favoritesController = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController
        detailController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func isFavorite() -> Bool {
        return topController?.games.first?.isFavorite ?? false &&
        detailController?.game?.isFavorite ?? false &&
        favoritesController?.games.first?.isFavorite ?? false
    }
    
    func testFavoriteGameNotification() {
        guard let topController = topController else {
            XCTAssert(false, "Bug: not instantiate TopGamesViewController")
            return
        }
        
        guard let favoritesController = favoritesController else {
            XCTAssert(false, "Bug: not instantiate FavoritesViewController")
            return
        }
        
        guard let detailController = detailController else {
            XCTAssert(false, "Bug: not instantiate DetailViewController")
            return
        }
        
        game.isFavorite = nil
        detailController.game = game
        
        _ = detailController.view
        _ = topController.view
        _ = favoritesController.view
        
        topController.games = [game]
        favoritesController.games = [game]
        
        XCTAssert(!isFavorite(), "Bug: game should not be favorite")
        topController.favoriteGame(game)
        XCTAssert(isFavorite(), "Bug: not favorite game")
        topController.favoriteGame(game)
        XCTAssert(!isFavorite(), "Bug: game should not be favorite")
        
        detailController.didTapButtonStar(detailController.buttonStar)
        XCTAssert(isFavorite(), "Bug: not favorite game")
        detailController.didTapButtonStar(detailController.buttonStar)
        XCTAssert(!isFavorite(), "Bug: game should not be favorite")
        
        detailController.didTapButtonStar(detailController.buttonStar)
        XCTAssert(isFavorite(), "Bug: not favorite game")
        favoritesController.removeFromFavorites(game: game)
        XCTAssert(!isFavorite(), "Bug: game should not be favorite")
    }
    
    func testTopViewControllerearchBar() {
        guard let topController = topController else {
            XCTAssert(false, "Bug: not instantiate TopGamesViewController")
            return
        }
        _ = topController.view
        topController.games = [game, gameTwo]
        topController.collection.reloadData()
        XCTAssert(topController.collection.numberOfItems(inSection: 0) == 2, "Bug: not add games in collection")
        
        topController.searchBar.text = "game test 1"
        topController.searchBar(topController.searchBar, textDidChange: "game test 1")
        topController.searchBarSearchButtonClicked(topController.searchBar)
    
        XCTAssert(topController.collection.numberOfItems(inSection: 0) == 1, "Bug: searchBar not work")
    }
    
}
