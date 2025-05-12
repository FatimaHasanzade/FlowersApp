//
//  UserDefaultsManager.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 07.05.25.
//

import UIKit

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let categoriesKey = "SavedCategories"
    private let favoritesKey = "FavoriteCategories"
    
    private init() {}
    
    // MARK: - Category Management
    
    func saveCategory(_ category: CategoryCardModel) {
        var categories = getCategories()
        
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
        } else {
            categories.append(category)
        }
        
        saveCategories(categories)
    }
    
    func updateCategory(_ category: CategoryCardModel, at id: Int) {
        var categories = getCategories()
        
        guard let index = categories.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        categories[index] = category
        saveCategories(categories)
    }
    
    func deleteCategory(at id: Int) {
        var categories = getCategories()
        let initialCount = categories.count
        
        categories.removeAll { $0.id == id }
        
        if categories.count < initialCount {
            saveCategories(categories)
        }
    }
    
    func getCategories() -> [CategoryCardModel] {
        guard let data = UserDefaults.standard.data(forKey: categoriesKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([CategoryCardModel].self, from: data)
        } catch {
            return []
        }
    }
    
    private func saveCategories(_ categories: [CategoryCardModel]) {
        do {
            let encoded = try JSONEncoder().encode(categories)
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        } catch {
        }
    }

    // MARK: - Favorite Management
    
    func saveFavorite(id: Int) {
        var favorites = getFavorites()
        guard !favorites.contains(id) else { return }
        
        favorites.append(id)
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func removeFavorite(id: Int) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == id }
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func isFavorite(id: Int) -> Bool {
        getFavorites().contains(id)
    }
    
    private func getFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
}
