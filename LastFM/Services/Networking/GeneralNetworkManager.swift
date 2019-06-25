//
//  GeneralNetworkManager.swift
//  LastFM
//
//  Created by Bruno Tavares on 25/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import UIKit

class GeneralNetworkManager {
    
    static let shared = GeneralNetworkManager()
    
    private init(){}
    
    func downloadImage(fromUrl urlString: String, onSuccess: @escaping (UIImage) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in
            
            if let error = error {
                onError(error)
                return
            }
            
            if let data = data {
                guard let image = UIImage(data: data) else {
                    onError(NSError(domain: "Error decoding image", code: 4, userInfo: nil))
                    return
                }
                
                onSuccess(image)
            }
        }
        
        task.resume()
    }
}
