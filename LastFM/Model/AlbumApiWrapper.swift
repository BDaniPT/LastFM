//
//  AlbumApiWrapper.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

struct AlbumApiWrapper {
    let response: AlbumApiResponse
}

extension AlbumApiWrapper: Decodable {
    
    private enum AlbumApiWrapperCodingKeys: String, CodingKey {
        case albums
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumApiWrapperCodingKeys.self)
        
        response = try container.decode(AlbumApiResponse.self, forKey: .albums)
    }
}
