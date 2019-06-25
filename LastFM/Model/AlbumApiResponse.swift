//
//  AlbumApiResponse.swift
//  LastFM
//
//  Created by Bruno Tavares on 23/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import Foundation

struct AlbumApiResponse {
    let attributes: AlbumApiResponseAttributes
    let topAlbums: [TopAlbum]
}

extension AlbumApiResponse: Decodable {
    
    private enum AlbumApiResponseCodingKeys: String, CodingKey {
        case attributes = "@attr"
        case album
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumApiResponseCodingKeys.self)
        
        attributes = try container.decode(AlbumApiResponseAttributes.self, forKey: .attributes)
        topAlbums = try container.decode([TopAlbum].self, forKey: .album)
    }
}

struct AlbumApiResponseAttributes {
    let tag: String
    let currentPage: Int
    let resultsPerPage: Int
    let numberOfPages: Int
    let total: Int
}

extension AlbumApiResponseAttributes: Decodable {
    
    private enum AlbumApiResponseAttributessCodingKeys: String, CodingKey {
        case tag
        case page
        case perPage
        case totalPages
        case total
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumApiResponseAttributessCodingKeys.self)
        
        tag = try container.decode(String.self, forKey: .tag)
        currentPage = try Int(container.decode(String.self, forKey: .page)) ?? 0
        resultsPerPage = try Int(container.decode(String.self, forKey: .perPage)) ?? 0
        numberOfPages = try Int(container.decode(String.self, forKey: .totalPages)) ?? 0
        total = try Int(container.decode(String.self, forKey: .total)) ?? 0
        
    }
}
