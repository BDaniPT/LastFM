//
//  LastFMApiMethod.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

enum LastFMApiMethod: String {
    
    case getTopAlbums     = "/2.0/?method=tag.gettopalbums"
    case getAlbumDetails   = "/2.0/?method=album.getinfo"
    
    func string() -> String {
        return self.rawValue
    }
}
