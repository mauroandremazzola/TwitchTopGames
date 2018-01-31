//
//  GameCell.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 27/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit

protocol GameCellDelegate: class {
    func didTapStarFor(cell: GameCell)
}

class GameCell: UICollectionViewCell {

    static let identifier = "GameCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var buttonStar: UIButton!
    
    weak var delegate : GameCellDelegate?
    
    var isFavorite : Bool? {
        didSet {
            guard let isFavorite = isFavorite else { return }
            buttonStar.tintColor = isFavorite ? .starSelected : .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class func getUINib() -> UINib? {
        return UINib(nibName: identifier, bundle: nil)
    }

    @IBAction func didTapSatar(_ sender: UIButton) {
        delegate?.didTapStarFor(cell: self)
    }
    
}
