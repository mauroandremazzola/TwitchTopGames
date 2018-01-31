//
//  APITests.swift
//  TwitchTopGamesTests
//
//  Created by Mauro André Barros Mazzola on 31/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import XCTest
@testable import TwitchTopGames

class APITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    var json : String?
    
    func testGameAPIAndDecodeGame() {
        let config = GameAPI.getTopGames(offset: 0, limit: 20).requestConfig()
        ServiceAPI.request(config: config, success: { (json) in
            self.json = json
        }) { (error, message) in }
        let pred = NSPredicate(format: "json != nil")
        let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
        let res = XCTWaiter.wait(for: [exp], timeout: 50)
        if res == XCTWaiter.Result.completed {
            guard let json = json else {
                XCTAssert(false, "json is nil")
                return
            }
            guard let response = JSONDecoder.decode(TwitchAPIResponse.self, from: json) else {
                XCTAssert(false, "Bug: decode games")
                return
            }
            XCTAssert(response.games.count == 20, "Bug: need 20 games")
        } else {
            XCTAssert(false, "Bug: ")
        }
    }
    
}
