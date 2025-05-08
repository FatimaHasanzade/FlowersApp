//
//  CategoriesViewModel.swift
//  FlowersApp
//
//  Created by Fatime on 05.05.25.
//

import UIKit

struct CategoriesViewModel {
    var categoriesList: [CategoryCardModel] = [
        .init(id:1,title: "Anemone", image: Images.Category.flower_1, color: UIColor.Cards.flower1, borderColor: UIColor.Cards.flower1, isFavorite: false),
        .init(id:2,title: "Camellia", image: Images.Category.flower_2, color: UIColor.Cards.flower2, borderColor: UIColor.Cards.flower2, isFavorite: false),
        .init(id:3,title: "Cosmos", image: Images.Category.flower_3, color: UIColor.Cards.flower3, borderColor: UIColor.Cards.flower3, isFavorite: false),
        .init(id:4,title: "Dahlia", image: Images.Category.flower_4, color: UIColor.Cards.flower4, borderColor: UIColor.Cards.flower4, isFavorite: false),
        .init(id:5,title: "Freesia", image: Images.Category.flower_5, color: UIColor.Cards.flower5, borderColor: UIColor.Cards.flower5, isFavorite: false),
        .init(id:6,title: "Hydrangea", image: Images.Category.flower_6, color: UIColor.Cards.flower6, borderColor: UIColor.Cards.flower6, isFavorite: false),
        .init(id:7,title: "Lily of the Valley", image: Images.Category.flower_7, color: UIColor.Cards.flower7, borderColor: UIColor.Cards.flower7, isFavorite: false),
        .init(id:8,title: "Orchid", image: Images.Category.flower_8, color: UIColor.Cards.flower8, borderColor: UIColor.Cards.flower8, isFavorite: false),
        .init(id:9,title: "Peony", image: Images.Category.flower_9, color: UIColor.Cards.flower9, borderColor: UIColor.Cards.flower9, isFavorite: false),
        .init(id:10,title: "Zinnia", image: Images.Category.flower_10, color: UIColor.Cards.flower10, borderColor: UIColor.Cards.flower10, isFavorite: false),
    ]
    
    // MARK: - Initialization
    init() {
        updateFavoriteStatus()
    }
    
    // MARK: - Methods
    mutating func updateFavoriteStatus() {
        for i in 0..<categoriesList.count {
            let isFavorite = UserDefaultsManager.shared.isFavorite(id: categoriesList[i].id)
            categoriesList[i].isFavorite = isFavorite
        }
    }
    
    mutating func toggleFavorite(at index: Int) {
        let id = categoriesList[index].id
        let isFavorite = categoriesList[index].isFavorite
        
        if isFavorite {
            UserDefaultsManager.shared.removeFavorite(id: id)
        } else {
            UserDefaultsManager.shared.saveFavorite(id: id)
        }
        
        categoriesList[index].isFavorite = !isFavorite
    }
    
    func getFavoriteCategories() -> [CategoryCardModel] {
        return categoriesList.filter { $0.isFavorite }
    }
    
    // MARK: - Search Functionality
       func searchCategories(with query: String) -> [CategoryCardModel] {
           let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
           
           guard !trimmedQuery.isEmpty else {
               return categoriesList
           }
           
           return categoriesList.filter {
               $0.title.lowercased().contains(trimmedQuery.lowercased())
           }
       }
}
