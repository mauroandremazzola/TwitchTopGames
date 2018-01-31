//
//  GameCollectionViewCell.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 27/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    static let identifier = "GameCollectionViewCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func getUINib() -> UINib? {
        return UINib(nibName: "GameCollectionViewCell", bundle: nil)
    }
    
}
