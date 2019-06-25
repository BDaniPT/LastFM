//
//  OnlineImageView.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import UIKit

fileprivate let imageCache = NSCache<AnyObject, AnyObject>()

class OnlineImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImage(fromUrlString urlString: String) {
        
        imageUrlString = urlString
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        GeneralNetworkManager.shared.downloadImage(fromUrl: urlString, onSuccess: { [weak self] image in
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                if urlString == weakSelf.imageUrlString {
                    weakSelf.image = image
                }
                
                imageCache.setObject(image, forKey: urlString as AnyObject)
            }
        }, onError: { error in
            print(error)
        })
    }
}
