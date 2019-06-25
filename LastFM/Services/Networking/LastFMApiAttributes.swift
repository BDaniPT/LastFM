//
//  LastFMApiAttributes.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

enum LastFMApiAttributes: String {
    
    case album
    case artist
    case apiKey = "api_key"
    case format
    case tag
    case page
    
    func string() -> String {
        return self.rawValue
    }
}
