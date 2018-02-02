//
//  TopGamesViewController.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 26/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit
import AlamofireImage

class TopGamesViewController: UIViewController {
    

    @IBOutlet weak var activityIndicator: ActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonReload: UIButton!
    @IBOutlet weak var stackPlaceholder: UIStackView!
    
    @IBOutlet weak var collection: UICollectionView! {
        didSet {
            collection.register(GameCell.getUINib(), forCellWithReuseIdentifier: GameCell.identifier)
            collection.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var labelPlaceholderInfo: UILabel! {
        didSet {
            labelPlaceholderInfo.numberOfLines = 0
        }
    }
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Update")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var page = 0
    private let limit = 20
    private var offset : Int {
        get {
            return page * limit
        }
    }
    
    internal var games = [Game]() {
        didSet {
            reloadCollection()
            buttonReload.isHidden = games.count > 0
        }
    }
    
    fileprivate var filtered = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGames()
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToFavorites(_:)), name: .addToFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveFromFavorites(_:)), name: .removeFromFavorites, object: nil)
        updateNumberOfItemsPerRow()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateNumberOfItemsPerRow()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller  = segue.destination as? DetailViewController, let game = sender as? Game {
            controller.game = game
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK - methods
    
    @objc func refresh() {
        page = 0
        games.removeAll()
        loadGames()
    }
    
    //MARK - notification IBActions
    
    @IBAction func didTapReload(_ sender: UIButton) {
        loadGames()
    }
    
    //MARK - notification methods
    
    @objc func didAddToFavorites(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo, let id = userInfo[GameKeys.id] as? Int32 else { return }
       updateFavoriteGame(id:id, isFavorite: true)
    }
    
    @objc func didRemoveFromFavorites(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo, let id = userInfo[GameKeys.id] as? Int32 else { return }
        updateFavoriteGame(id:id, isFavorite: false)
    }

    //MARK - internal
    
    internal func favoriteGame(_ game: Game) {
        let dataManager = DataManager()
        let userInfo : [GameKeys : Any] = [.id : game.id]
        if let favorite = dataManager.findGame(id: game.id) {
            dataManager.removeFromFavorite(game: favorite)
            NotificationCenter.default.post(name: .removeFromFavorites, object: nil, userInfo: userInfo)
        } else {
            dataManager.addToFavorites(game)
            game.isFavorite = true
            NotificationCenter.default.post(name: .addToFavorites, object: nil, userInfo: userInfo)
        }
        reloadCollection()
    }
    
    //MARK - fileprivate
    
    fileprivate func reloadCollection() {
        if let text = searchBar.text, !text.isEmpty {
            filtered = games.filter{ $0.name?.range(of: text, options: .caseInsensitive) != nil }
        } else {
            filtered = games
        }
        collection.reloadData()
    }
    
    fileprivate func getGamePosition(_ game: Game) -> String {
        if let index = games.index(of: game) {
            return "#\(index + 1) "
        }
        return ""
    }
    
    //MARK - privates
    
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
    
    private func updateFavoriteGame(id: Int32, isFavorite: Bool) {
        if let index = games.index(where: { $0.id == id })   {
            games[index].isFavorite = isFavorite
        }
        reloadCollection()
    }
    
    private func loadGames() {
        startActivityIndicator()
        let config = GameAPI.getTopGames(offset: offset, limit: limit).requestConfig()
        ServiceAPI.request(config: config, success: { (result) in
            guard let value = result, let response = JSONDecoder.decode(TwitchAPIResponse.self, from: value) else {
                self.stopActivityIndicator()
                return
            }
            self.games.append(contentsOf: response.games)
            self.page += 1
            self.stopActivityIndicator()
        }) { (error, errorMessage) in
            self.stopActivityIndicator()
            self.showAlertMessage(errorMessage)
        }
    }

    private func startActivityIndicator() {
        activityIndicator.startAnimating()
        collection.alpha = 0.4
        collection.isUserInteractionEnabled = false
        stackPlaceholder.isHidden =  true
    }
    
    private func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        collection.isUserInteractionEnabled = true
        collection.alpha = 1
        refreshControl.endRefreshing()
        if games.count <= 0 {
            stackPlaceholder.isHidden = false
            collection.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    private func showAlertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension TopGamesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadCollection()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TopGamesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as? GameCell else {
            fatalError()
        }
        let game = filtered[indexPath.item]
        cell.image.af_setSafeImage(withURL: game.image, placeholderImage: #imageLiteral(resourceName: "gamePlaceholder"))
        cell.title.text = getGamePosition(game) + (game.name ?? "")
        cell.isFavorite = game.isFavorite
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = filtered[indexPath.item]
        performSegue(withIdentifier: "showDetail", sender: game)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < 0 { return }
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height {
            loadGames()
        }
    }
}

extension TopGamesViewController: GameCellDelegate {
    
    func didTapStarFor(cell: GameCell) {
        if let indexPath = collection.indexPath(for: cell) {
            let game = filtered[indexPath.item]
            favoriteGame(game)
        }
    }
}
