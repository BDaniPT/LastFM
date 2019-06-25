//
//  TopAlbum.swift
//  LastFM
//
//  Created by Bruno Tavares on 23/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import Foundation

struct TopAlbum {
    let albumName: String
    let artist: Artist
    let albumImage: [AlbumImage]

    func getImageUrl(forImageSize imageSize: ImageSize) -> String? {
        
        return albumImage.first(where:{$0.size == imageSize})?.urlString
    }
}

extension TopAlbum: Decodable {
    private enum TopAlbumCodingKeys: String, CodingKey {
        case name
        case image
        case artist
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopAlbumCodingKeys.self)
        
        albumName = try container.decode(String.self, forKey: .name)
        artist = try container.decode(Artist.self, forKey: .artist)
        albumImage = try container.decode([AlbumImage].self, forKey: .image)
    }
}

struct AlbumImage {
    let urlString: String
    let size: ImageSize
}

extension AlbumImage: Decodable {
    private enum AlbumImageCodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumImageCodingKeys.self)
        
        urlString = try container.decode(String.self, forKey: .url)
        let sizeString = try container.decode(String.self, forKey: .size)
        size = ImageSize(rawValue: sizeString) ?? .other
    }
}

enum ImageSize: String, Decodable {
    case small
    case medium
    case large
    case extraLarge = "extralarge"
    case mega
    case other
}

struct Artist {
    let name: String
}

extension Artist: Decodable {
    private enum ArtistCodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArtistCodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
    }
}
