//
//  MusicModel.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit
import Foundation


struct MusicResultModel:Codable {
    let resultCount: Int?
    let results: [MusicModel]?
}

struct MusicModel:Codable {
    
    let wrapperType: String?
    let kind: String?
    let artistId: Double?
    let collectionId: Double?
    let trackId: Double?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Double?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
    
    func deleteFavoriteToUserDefaults(delete: MusicModel) {
        var existingFavorite = MusicModel.getAllFavoriteFromUserDefaults()
        existingFavorite?.removeAll(where: {$0.artistId == delete.artistId && $0.collectionId == delete.collectionId && $0.trackId == delete.trackId})
        let defaults = UserDefaults.standard
        let encodedData = try? JSONEncoder().encode(existingFavorite)
        defaults.set(encodedData, forKey: "FavoriteModels")
    }
    
    func saveFavoriteToUserDefaults(favorite: MusicModel) {
        var toSave = [MusicModel]()
        let existingFavorite = MusicModel.getAllFavoriteFromUserDefaults()
        if let _ = existingFavorite?.first(where: {$0.artistId == favorite.artistId && $0.collectionId == favorite.collectionId && $0.trackId == favorite.trackId}) {
            //existing -> return
            return
        }
        toSave.append(contentsOf: existingFavorite ?? [])
        toSave.append(favorite)
        let defaults = UserDefaults.standard
        let encodedData = try? JSONEncoder().encode(toSave)
        defaults.set(encodedData, forKey: "FavoriteModels")
    }

    public static func getAllFavoriteFromUserDefaults() -> [MusicModel]? {
        let defaults = UserDefaults.standard
        if let encodedData = defaults.data(forKey: "FavoriteModels") {
            let searchResult = try? JSONDecoder().decode([MusicModel].self, from: encodedData)
            return searchResult
        }
        return nil
    }
}

//song name, artist, and album art.
