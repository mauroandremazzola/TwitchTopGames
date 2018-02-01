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

    @IBOutlet weak var viewPlaceholder: UIView! {
        didSet {
            viewPlaceholder.isHidden = true
        }
    }
    
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.register(GameCell.getUINib(), forCellWithReuseIdentifier: GameCell.identifier)
        }
    }
    
    private let dataManager = DataManager()
    
    internal var games = [Game]() {
        didSet {
            collection.reloadData()
            viewPlaceholder.isHidden = games.count > 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavorites()
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToFavorites(_:)), name: .addToFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveFromFavorites(_:)), name: .removeFromFavorites, object: nil)
        updateNumberOfItemsPerRow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateNumberOfItemsPerRow()
        }
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
    
    private func updateNumberOfItemsPerRow() {
        let orientation = UIDevice.current.orientation
        guard let layout = collection?.collectionViewLayout as? GridViewLayout else { return }
        
        if UIDeviceOrientationIsPortrait(orientation) {
            layout.setNumberOfItemsPerRow(itensPerRow: 2, minimumInteritemSpacing: 5, minimumLineSpacing: 5)
        } else {
            layout.setNumberOfItemsPerRow(itensPerRow: 3, minimumInteritemSpacing: 5, minimumLineSpacing: 5)
        }
        layout.invalidateLayout()
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
