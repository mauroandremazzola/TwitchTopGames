//
// UICollectionView.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 29/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func setNumberOfItensForRow(itens: Int, spacing: CGFloat = 5, height: CGFloat? = nil, minimumLineSpacing: CGFloat? = nil) {
        let layout = UICollectionViewFlowLayout()
        let totalSpacing = CGFloat(itens - 1) * spacing
        let width = (self.contentSize.width - totalSpacing) / CGFloat(itens)
        layout.itemSize.width = width
        layout.minimumInteritemSpacing = CGFloat(spacing)
        layout.itemSize.height = height != nil ? height! : layout.itemSize.width
        layout.minimumLineSpacing =  minimumLineSpacing != nil ? minimumLineSpacing! : spacing
        
        collectionViewLayout = layout
    }
    
}
