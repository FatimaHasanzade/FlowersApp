//
//  protocols.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 12.05.25.
//

import Foundation
import UIKit

protocol CategoryCardCellDelegate: AnyObject {
    func didTapHeart(on cell: CategoryCardCell)
    func didTapAddToCart(on cell: CategoryCardCell)
    func didTapDelete(on cell: CategoryCardCell)
    func didTapUpdate(on cell: CategoryCardCell)
}

protocol FavoritesUpdateDelegate: AnyObject {
    func didUpdateFavorites()
}

protocol CreateViewControllerDelegate: AnyObject {
    func didCreateNewCategory(_ category: CategoryCardModel)
    func didUpdateCategory(_ category: CategoryCardModel, at index: Int)
    func didDeleteCategory(at id: Int)
}

protocol NavigationRouter {
    func navigateToDetail(model: CategoryCardModel, from: UIViewController)
    func navigateToFavorites(favorites: [CategoryCardModel], from: UIViewController)
    func navigateToCreate(category: CategoryCardModel?, index: Int?, from: UIViewController)
}
