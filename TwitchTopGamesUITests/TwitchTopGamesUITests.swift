//
//  TwitchTopGamesUITests.swift
//  TwitchTopGamesUITests
//
//  Created by Mauro André Barros Mazzola on 31/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import XCTest

class TwitchTopGamesUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTopGamesToFavoritesBackTopGames() {
        let app = XCUIApplication()
        let navFavorite = app.navigationBars["Favorites"]
        let navTopGames = app.navigationBars["Top Games"]
        let tabBarsQuery = XCUIApplication().tabBars
        let tabTopGames = tabBarsQuery.buttons["Most Viewed"]
        let tabFavorite = tabBarsQuery.buttons["Favorites"]

        tabFavorite.tap()
        XCTAssert(navFavorite.exists, "The Favorites view navigation bar does not exist")
        tabTopGames.tap()
        XCTAssert(navTopGames.exists, "The Top Games view navigation bar does not exist")
    }

    func testTopGamesToDetailBackTopGames() {
        let app = XCUIApplication()
        let navTopGames = app.navigationBars["Top Games"]
        let navDetail = app.navigationBars["Detail"]
        app.collectionViews.cells.firstMatch.tap()
        XCTAssert(navDetail.exists, "The Detail view navigation bar does not exist")
        navDetail.buttons["Top Games"].tap()
        XCTAssert(navTopGames.exists, "The top games view navigation bar does not exist")
    }

    func testFavoriteToDetailBackFavorite() {
        let app = XCUIApplication()
        let navFavorite = app.navigationBars["Favorites"]
        let navDetail = app.navigationBars["Detail"]
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons["Favorites"].tap()
        app.collectionViews.cells.firstMatch.tap()
        XCTAssert(navDetail.exists, "The Detail view navigation bar does not exist")
        navDetail.buttons["Favorites"].tap()
        XCTAssert(navFavorite.exists, "The Favorites view navigation bar does not exist")
    }

}

