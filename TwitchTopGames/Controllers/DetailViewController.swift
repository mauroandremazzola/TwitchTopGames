//
//  DetailViewController.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 27/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var buttonStar: UIBarButtonItem!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelviewers: UILabel!
    @IBOutlet weak var labelName: UILabel! {
        didSet{
            labelName.numberOfLines = 0
        }
    }
    
    var game : Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        NotificationCenter.default.addObserver(self, selector: #selector(didAddToFavorites(_:)), name: .addToFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveFromFavorites(_:)), name: .removeFromFavorites, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdatedViewers(_:)), name: .updatedViewers, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - notification methods
    
    @objc func didAddToFavorites(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let id = userInfo[GameKeys.id] as? Int32, id == game?.id {
            game?.isFavorite = true
            buttonStar.tintColor = .starSelected
        }
    }
    
    @objc func didRemoveFromFavorites(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let id = userInfo[GameKeys.id] as? Int32, id == game?.id {
            game?.isFavorite = false
            buttonStar.tintColor = .white
        }
    }
    
    @objc func didUpdatedViewers(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let id = userInfo[GameKeys.id] as? Int32,
            let viewers = userInfo[GameKeys.viewers] as? Int32 else { return }
       
        if game?.id == id {
            game?.viewers = viewers
            labelviewers.text = "\(viewers)"
        }
    }

    //MARK - private
    
    private func initUI() {
        image.af_setSafeImage(withURL: game?.image, placeholderImage: #imageLiteral(resourceName: "gamePlaceholder"))
        labelName.text = game?.name
        if let viewers = game?.viewers {
            labelviewers.text = "\(viewers)"
        }
        
        if let isFavorite = game?.isFavorite {
            buttonStar.tintColor = isFavorite ? .yellow : .white
        }
    }
    
    //MARK - IBActions
    
    @IBAction func didTapButtonStar(_ sender: UIBarButtonItem) {
        guard let game = game else { return }
        let dataManager = DataManager()
        let userInfo : [GameKeys : Any] = [.id : game.id]
        
        if let favorite = dataManager.findGame(id: game.id) {
            dataManager.removeFromFavorite(game: favorite)
            buttonStar.tintColor = .white
            NotificationCenter.default.post(name: .removeFromFavorites, object: nil, userInfo: userInfo)
        } else {
            dataManager.addToFavorites(game)
            buttonStar.tintColor = .starSelected
            NotificationCenter.default.post(name: .addToFavorites, object: nil, userInfo: userInfo)
        }
    }
    

}
