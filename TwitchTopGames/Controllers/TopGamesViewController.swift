//
//  TopGamesViewController.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 26/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit

class TopGamesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - private
    
    private func loadGames() {
        let config = GameAPI.getTopGames(offset: 0, limit: 20).requestConfig() //next 20 - 20, 40 - 20
        ServiceAPI.request(config: config) { (result) in
            print(result ?? "")
        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}

