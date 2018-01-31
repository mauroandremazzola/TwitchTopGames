//
//  ActivityIndicatorView.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 27/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIActivityIndicatorView {

    @IBInspectable
    var showWhenStarted : Bool = false
    
    override func startAnimating() {
        super.startAnimating()
        if showWhenStarted {
            self.isHidden = false
        }
    }
}
