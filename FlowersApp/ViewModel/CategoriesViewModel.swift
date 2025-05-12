//
//  CategoriesViewModel.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 04.05.25.
//

import UIKit

struct CategoriesViewModel {
    var categoriesList: [CategoryCardModel] = []

    init() {
        setupInitialCategories()
        loadUserCreatedCategories()
        updateFavoriteStatus()
    }

    // MARK: - Setup
    private mutating func setupInitialCategories() {
        categoriesList = [
            .init(title: "Anemone", image: Images.Category.flower_1, color: UIColor.Cards.flower1, borderColor: UIColor.Cards.flower1, isFavorite: false, isUserCreated: false),
            .init(title: "Camellia", image: Images.Category.flower_2, color: UIColor.Cards.flower2, borderColor: UIColor.Cards.flower2, isFavorite: false, isUserCreated: false),
            .init(title: "Cosmos", image: Images.Category.flower_3, color: UIColor.Cards.flower3, borderColor: UIColor.Cards.flower3, isFavorite: false, isUserCreated: false),
            .init(title: "Dahlia", image: Images.Category.flower_4, color: UIColor.Cards.flower4, borderColor: UIColor.Cards.flower4, isFavorite: false, isUserCreated: false),
            .init(title: "Freesia", image: Images.Category.flower_5, color: UIColor.Cards.flower5, borderColor: UIColor.Cards.flower5, isFavorite: false, isUserCreated: false),
            .init(title: "Hydrangea", image: Images.Category.flower_6, color: UIColor.Cards.flower6, borderColor: UIColor.Cards.flower6, isFavorite: false, isUserCreated: false),
            .init(title: "Lily of the Valley", image: Images.Category.flower_7, color: UIColor.Cards.flower7, borderColor: UIColor.Cards.flower7, isFavorite: false, isUserCreated: false),
            .init(title: "Orchid", image: Images.Category.flower_8, color: UIColor.Cards.flower8, borderColor: UIColor.Cards.flower8, isFavorite: false, isUserCreated: false),
            .init(title: "Peony", image: Images.Category.flower_9, color: UIColor.Cards.flower9, borderColor: UIColor.Cards.flower9, isFavorite: false, isUserCreated: false),
            .init(title: "Zinnia", image: Images.Category.flower_10, color: UIColor.Cards.flower10, borderColor: UIColor.Cards.flower10, isFavorite: false, isUserCreated: false),
        ]
    }

    private mutating func loadUserCreatedCategories() {
        let userCategories = UserDefaultsManager.shared.getCategories()
        categoriesList.append(contentsOf: userCategories.filter { $0.isUserCreated })
    }

    // MARK: - Favorites
    mutating func updateFavoriteStatus() {
        for i in categoriesList.indices {
            let id = categoriesList[i].id
            categoriesList[i].isFavorite = UserDefaultsManager.shared.isFavorite(id: id)
        }
    }

    mutating func toggleFavorite(categoryId: Int) {
        guard let index = categoriesList.firstIndex(where: { $0.id == categoryId }) else {
            return
        }

        let isFavorite = categoriesList[index].isFavorite
        let id = categoriesList[index].id

        if isFavorite {
            UserDefaultsManager.shared.removeFavorite(id: id)
        } else {
            UserDefaultsManager.shared.saveFavorite(id: id)
        }

        categoriesList[index].isFavorite.toggle()
    }

    func getFavoriteCategories() -> [CategoryCardModel] {
        return categoriesList.filter { $0.isFavorite }
    }

    // MARK: - Search
    func searchCategories(with query: String) -> [CategoryCardModel] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return categoriesList }

        return categoriesList.filter {
            $0.title.lowercased().contains(trimmedQuery.lowercased())
        }
    }

    // MARK: - CRUD
    mutating func addCategory(_ category: CategoryCardModel) {
        categoriesList.append(category)
    }

    mutating func updateCategory(_ category: CategoryCardModel, at index: Int) {
        guard categoriesList.indices.contains(index) else {
            return
        }
        categoriesList[index] = category
    }

    mutating func deleteCategory(withId id: Int) {
        guard let index = categoriesList.firstIndex(where: { $0.id == id }) else {
            return
        }

        categoriesList.remove(at: index)
        UserDefaultsManager.shared.deleteCategory(at: id)
    }
}
