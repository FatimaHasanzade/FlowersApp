//
//  CartViewController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 05.05.25.
//

import UIKit
import SnapKit

class CartViewController: UIViewController, CategoryCardCellDelegate, CreateViewControllerDelegate {
    
    // MARK: - CategoryCardCellDelegate Methods
    func didTapHeart(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let item = cartItems[indexPath.row]
        
        UserDefaultsManager.shared.saveFavorite(id: item.id)
        
        let alert = UIAlertController(title: "Success", message: "\(item.title) has been added to favorites!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didTapAddToCart(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let item = cartItems[indexPath.row]
        
        CartManager.shared.removeFromCart(id: item.id)
        cartItems = CartManager.shared.getCartItems()
        collectionView.reloadData()
        checkEmptyState()
        
        let alert = UIAlertController(title: "Success", message: "\(item.title) has been removed from the cart!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didTapDelete(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let item = cartItems[indexPath.row]
        
        let alert = UIAlertController(title: "Delete", message: "Do you want to remove \(item.title) from the cart?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            CartManager.shared.removeFromCart(id: item.id)
            self.cartItems = CartManager.shared.getCartItems()
            self.collectionView.reloadData()
            self.checkEmptyState()
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func didTapUpdate(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let selectedModel = cartItems[indexPath.row]
        let createVC = CreateViewController(router: router, category: selectedModel, index: indexPath.row)
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    // MARK: - CreateViewControllerDelegate Methods
    func didCreateNewCategory(_ category: CategoryCardModel) {
        // Not applicable for cart, but required by protocol
    }
    
    func didUpdateCategory(_ category: CategoryCardModel, at index: Int) {
        CartManager.shared.updateCartItem(category, at: index)
        cartItems = CartManager.shared.getCartItems()
        collectionView.reloadData()
        checkEmptyState()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    
    func didDeleteCategory(at index: Int) {
        guard index < cartItems.count else { return }
        let item = cartItems[index]
        CartManager.shared.removeFromCart(id: item.id)
        cartItems = CartManager.shared.getCartItems()
        collectionView.reloadData()
        checkEmptyState()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
    
    // MARK: - Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCardCell.self, forCellWithReuseIdentifier: "CategoryCardCell")
        return collectionView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No cart items"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var cartItems: [CategoryCardModel]
    var router: Router
    
    // MARK: - Initializers
    init(router: Router) {
        self.router = router
        self.cartItems = CartManager.shared.getCartItems()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        layout()
        checkEmptyState()
        
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleCartUpdated),
                                             name: .cartUpdated,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleCategoryUpdated(_:)),
                                             name: .categoryUpdated,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleCategoryDeleted(_:)),
                                             name: .categoryDeleted,
                                             object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setup() {
        title = "Cart"
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        view.addSubview(imageView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Layout
    private func layout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Helper Methods
    private func checkEmptyState() {
        emptyStateLabel.isHidden = !cartItems.isEmpty
        imageView.isHidden = !cartItems.isEmpty
        tabBarItem.badgeValue = cartItems.isEmpty ? nil : "\(cartItems.count)"
    }
    
    // MARK: - Notification Handlers
    @objc private func handleCartUpdated() {
        cartItems = CartManager.shared.getCartItems()
        collectionView.reloadData()
        checkEmptyState()
    }
    
    @objc private func handleCategoryUpdated(_ notification: Notification) {
        if let category = notification.userInfo?["category"] as? CategoryCardModel,
           let index = notification.userInfo?["index"] as? Int,
           cartItems.contains(where: { $0.id == category.id }) {
            CartManager.shared.updateCartItem(category, at: index)
            cartItems = CartManager.shared.getCartItems()
            collectionView.reloadData()
            checkEmptyState()
        }
    }
    
    @objc private func handleCategoryDeleted(_ notification: Notification) {
        if let index = notification.userInfo?["index"] as? Int,
           index < cartItems.count {
            let item = cartItems[index]
            CartManager.shared.removeFromCart(id: item.id)
            cartItems = CartManager.shared.getCartItems()
            collectionView.reloadData()
            checkEmptyState()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCardCell", for: indexPath) as? CategoryCardCell else {
            return UICollectionViewCell()
        }
        
        let item = cartItems[indexPath.row]
        cell.model = item
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedModel = cartItems[indexPath.row]
        router.navigateToCategoryDetail(with: selectedModel)
    }
}
