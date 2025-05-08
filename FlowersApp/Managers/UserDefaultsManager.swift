//
//  UserDefaultsManager.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 07.05.25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let favoritesKey = "favoriteFlowers"
    
    private init() {}
    
    
    // MARK: - Public Methods

    func saveFavorite(id: Int) {
        var favorites = getFavorites()
        if !favorites.contains(id) {
            favorites.append(id)
            UserDefaults.standard.set(favorites, forKey: favoritesKey)
        }
    }
    
    func removeFavorite(id: Int) {
        var favorites = getFavorites()
        favorites.removeAll(where: { $0 == id })
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func isFavorite(id: Int) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(id)
    }
    
    
    func getFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
}
