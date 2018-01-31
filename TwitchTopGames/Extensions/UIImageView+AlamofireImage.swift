//
//  UIImageView+AlamofireImage.swift
//  TwitchTopGames
//
//  Created by Mauro André Barros Mazzola on 29/01/18.
//  Copyright © 2018 Mauro André Barros Mazzola. All rights reserved.
//

import Foundation
import AlamofireImage
import Alamofire

extension UIImageView {
    
    public func af_setSafeImage(
        withURL url: URL?,
        placeholderImage: UIImage? = nil,
        filter: ImageFilter? = nil,
        progress: ImageDownloader.ProgressHandler? = nil,
        progressQueue: DispatchQueue = DispatchQueue.main,
        imageTransition: ImageTransition = .noTransition,
        runImageTransitionIfCached: Bool = false,
        completion: ((DataResponse<UIImage>) -> Void)? = nil)
    {
        guard let safeURL = url else {
            image = placeholderImage
            print("problem with URL parameter: \(String(describing: url))")
            return
        }
        
        af_setImage(withURL: safeURL,
                    placeholderImage: placeholderImage,
                    filter: filter,
                    progress: progress,
                    progressQueue: progressQueue,
                    imageTransition: imageTransition,
                    runImageTransitionIfCached: runImageTransitionIfCached,
                    completion: completion)
    }
    
}
