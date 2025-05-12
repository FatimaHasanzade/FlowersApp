//
//  Router.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 03.05.25.
//

import UIKit

final class Router {
    let navigation: UINavigationController
    
    init(navigation:UINavigationController){
        self.navigation = navigation
    }
    
    private func push(controller:UIViewController){
        navigation.pushViewController(controller, animated: true)
    }
    
    private func pop(){
        navigation.popViewController(animated: true)
    }
    
    func pushCategoriesViewController(){
        let controller = CategoriesViewController(router: self)
        push(controller: controller)
    }
    
    func navigateToCategoryDetail(with model: CategoryCardModel) {
        let controller = CategoryDetailController(router: self, model: model)
        push(controller: controller)
    }
    
    func navigateToFavorites(with favorites: [CategoryCardModel]) {
        let controller = FavoritesViewController(router: self, favorites: favorites)
        push(controller: controller)
    }

}
