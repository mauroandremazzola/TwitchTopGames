//
//  FavoritesViewController.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 27/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

    private let dataManager = DataManager()
    
    internal var games = [Game]() {
        didSet {
            collection.reloadData()
        }
    }
    
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.register(GameCell.getUINib(), forCellWithReuseIdentifier: GameCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToFavorites(_:)), name: .addToFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveFromFavorites(_:)), name: .removeFromFavorites, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        collection.setNumberOfItensForRow(itens: 2, spacing: 10)
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller  = segue.destination as? DetailViewController, let game = sender as? Game {
            controller.game = game
        }
    }
    
    //MARK - notification methods
    
    @objc func didAddToFavorites(_ notification: NSNotification) {
        loadFavorites()
    }
    
    @objc func didRemoveFromFavorites(_ notification: NSNotification) {
        loadFavorites()
    }
    
    //MARK - internals
    
    internal func removeFromFavorites(game: Game) {
        let userInfo : [GameKeys : Any] = [.id : game.id]
        dataManager.removeFromFavorite(game: game)
        if let index = games.index(of: game) {
            games.remove(at: index)
        }
        NotificationCenter.default.post(name: .removeFromFavorites, object: nil, userInfo: userInfo)
    }
    
    //MARK - privates
    
    private func loadFavorites() {
        games = dataManager.loadFavorites()
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as? GameCell else {
            fatalError()
        }
        let game = games[indexPath.item]
        cell.title.text = game.name
        cell.image.af_setSafeImage(withURL: game.image)
        cell.isFavorite = game.isFavorite
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = games[indexPath.item]
        performSegue(withIdentifier: "showDetail", sender: game)
    }
}

extension FavoritesViewController: GameCellDelegate {
    
    func didTapStarFor(cell: GameCell) {
        if let indexPath = collection.indexPath(for: cell) {
            let game = games[indexPath.item]
            removeFromFavorites(game: game)
        }
    }
}
