//
//  CartManager.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 07.05.25.
//

import UIKit

class CartManager {
    static let shared = CartManager()
    
    private init() {}
    
    private var cartItems: [CategoryCardModel] = []
    
    func addToCart(item: CategoryCardModel) {
       
        if !isInCart(id: item.id) {
            
            cartItems.append(item)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
    }
    
    func removeFromCart(id: Int) {
        cartItems.removeAll { $0.id == id }
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    
    func getCartItems() -> [CategoryCardModel] {
        return cartItems
    }
    
    func isInCart(id: Int) -> Bool {
        return cartItems.contains { $0.id == id }
    }
    
    func clearCart() {
        cartItems.removeAll()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    func updateCartItem(_ item: CategoryCardModel, at index: Int) {
            guard index < cartItems.count else { return }
            cartItems[index] = item
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
}


