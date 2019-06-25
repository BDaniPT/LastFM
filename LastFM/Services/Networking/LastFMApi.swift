//
//  LastFMApi.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import Foundation

class LastFMApi {
    
    private static let baseUrl: String = "https://ws.audioscrobbler.com"
    private static var LastFMApiInstance: LastFMService?
    
    static var service: LastFMService {
        
        get {
            
            guard let lastFMInstance = LastFMApiInstance else {
                
                let newInstance = LastFMService(baseUrl)
                LastFMApiInstance = newInstance
                
                return newInstance
            }
            
            return lastFMInstance
        }
    }
}

class LastFMService: NSObject, URLSessionTaskDelegate {
    private static let token: String = "9be32700de5cb7897cb6d6b855e2222d"
    private static let jsonFormat = "json"
    
    private var baseUrl: String
    private lazy var session: URLSession = {
        
        return Foundation.URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: nil)
    }()
    
    init(_ url: String) {
        
        baseUrl = url
    }
    
    private func buildUrl(forMethod method: LastFMApiMethod, withUrlParameters urlParameters: [String:String]?) -> URL? {
        
        var url = self.baseUrl + method.string()
        guard let urlParameters = urlParameters else {
            return URL(string: url)
        }
        
        for parameter in urlParameters {
            url = "\(url)&\(parameter.key)=\(parameter.value)"
        }
        
        return URL(string:url)
    }
    
    // MARK: API Methods
    func getTopAlbums(forTag tag: String, andPage page: Int, onSuccess: @escaping ([TopAlbum]) -> Void, onError: @escaping (Error) -> Void) {
        
        let tagWithoutSpaces = tag.stringWithoutSpaces()
        var parameters: [String : String] = [:]
        parameters[LastFMApiAttributes.tag.string()] = tagWithoutSpaces
        parameters[LastFMApiAttributes.apiKey.string()] = LastFMService.token
        parameters[LastFMApiAttributes.format.string()] = LastFMService.jsonFormat
        parameters[LastFMApiAttributes.page.string()] = String(page)
        
        guard let url = buildUrl(forMethod: LastFMApiMethod.getTopAlbums, withUrlParameters: parameters) else {
            onError(NSError(domain: "Invalid URL", code: 1, userInfo: nil))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) -> Void in
            
            if let error = error {
                onError(error)
                return
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print(jsonData)
                    let apiResponse = try JSONDecoder().decode(AlbumApiWrapper.self, from: data)
                    onSuccess(apiResponse.response.topAlbums)
                } catch {
                    print(error)
                    onError(NSError(domain: "Unable to decode", code: 2, userInfo: nil))
                }
            } else {
                onError(NSError(domain: "Invalid data response", code: 3, userInfo: nil))
                return
            }
        }
        
        task.resume()
    }
    
    func getAlbumDetails(forAlbumName albumName: String, andArtist artist: String, onSuccess: @escaping (DetailedAlbum) -> Void, onError: @escaping (Error) -> Void) {
        
        let albumNameWithoutSpaces = albumName.stringWithoutSpaces()
        let artistNameWithoutSpaces = artist.stringWithoutSpaces()
        var parameters: [String : String] = [:]
        parameters[LastFMApiAttributes.artist.string()] = artistNameWithoutSpaces
        parameters[LastFMApiAttributes.album.string()] = albumNameWithoutSpaces
        parameters[LastFMApiAttributes.apiKey.string()] = LastFMService.token
        parameters[LastFMApiAttributes.format.string()] = LastFMService.jsonFormat
        
        guard let url = buildUrl(forMethod: LastFMApiMethod.getAlbumDetails, withUrlParameters: parameters) else {
            onError(NSError(domain: "Invalid URL", code: 1, userInfo: nil))
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) -> Void in
            
            if let error = error {
                onError(error)
                return
            }
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print(jsonData)
                    let apiResponse = try JSONDecoder().decode(DetailedAlbumWrapper.self, from: data)
                    onSuccess(apiResponse.response)
                } catch {
                    print(error)
                    onError(NSError(domain: "Unable to decode", code: 2, userInfo: nil))
                }
            } else {
                onError(NSError(domain: "Invalid data response", code: 3, userInfo: nil))
                return
            }
        }
        
        task.resume()
    }
}
