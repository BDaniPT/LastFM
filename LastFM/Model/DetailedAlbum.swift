//
//  DetailedAlbum.swift
//  LastFM
//
//  Created by Bruno Tavares on 23/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import Foundation

struct DetailedAlbumWrapper {
    let response: DetailedAlbum
}

extension DetailedAlbumWrapper: Decodable {
    
    private enum DetailedAlbumWrapperCodingKeys: String, CodingKey {
        case album
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DetailedAlbumWrapperCodingKeys.self)
        
        response = try container.decode(DetailedAlbum.self, forKey: .album)
    }
}

struct DetailedAlbum {
    let name: String
    let artist: String
    let listeners: Int
    let playCount: Int
    let publishDate: String?
    let trackAmount: Int
    let albumImage: [AlbumImage]
    
    func getImageUrl(forImageSize imageSize: ImageSize) -> String? {
        
        return albumImage.first(where:{$0.size == imageSize})?.urlString
    }
}

extension DetailedAlbum: Decodable {
    private enum DetailedAlbumCodingKeys: String, CodingKey {
        case name
        case artist
        case image
        case listeners
        case playCount = "playcount"
        case tracks
        case track
        case wiki
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DetailedAlbumCodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        artist = try container.decode(String.self, forKey: .artist)
        listeners = try Int(container.decode(String.self, forKey: .listeners)) ?? 0
        playCount = try Int(container.decode(String.self, forKey: .playCount)) ?? 0
        let wiki = try? container.decode(WikiWrapper.self, forKey: .wiki)
        publishDate = wiki?.publishDate
        let tracks = try container.decode([String:[Track]].self, forKey: DetailedAlbumCodingKeys.tracks)
        trackAmount = tracks.first?.value.count ?? 0
        albumImage = try container.decode([AlbumImage].self, forKey: .image)
    }
}


struct WikiWrapper {
    let publishDate: String
}

extension WikiWrapper: Decodable {
    private enum WikiWrapperCodingKeys: String, CodingKey {
        case published
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WikiWrapperCodingKeys.self)
        
        publishDate = try container.decode(String.self, forKey: .published)
    }
}

struct Track {
    let name: String
}

extension Track: Decodable {
    private enum TrackCodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TrackCodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
    }
}
