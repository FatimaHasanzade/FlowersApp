//
//  FavoritesViewController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 05.05.25.
//

import UIKit
import SnapKit

class FavoritesViewController: UIViewController, CategoryCardCellDelegate, CreateViewControllerDelegate {
    
    // MARK: - CategoryCardCellDelegate Methods
    func didTapHeart(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        removeFromFavorites(at: indexPath.row)
    }
    
    func didTapAddToCart(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let item = favoriteCategories[indexPath.row]
        CartManager.shared.addToCart(item: item)
        let alert = UIAlertController(title: "Success", message: "\(item.title) has been added to the cart!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func didTapDelete(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let item = favoriteCategories[indexPath.row]
        
        let alert = UIAlertController(title: "Delete", message: "Do you want to remove \(item.title) from favorites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.removeFromFavorites(at: indexPath.row)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func didTapUpdate(on cell: CategoryCardCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let selectedModel = favoriteCategories[indexPath.row]
        let createVC = CreateViewController(router: router, category: selectedModel)
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    // MARK: - CreateViewControllerDelegate Methods
    func didCreateNewCategory(_ category: CategoryCardModel) {
        // Not applicable for favorites, but required by protocol
    }
    
    func didUpdateCategory(_ category: CategoryCardModel, at index: Int) {
        guard index < favoriteCategories.count else { return }
        favoriteCategories[index] = category
        collectionView.reloadData()
        checkEmptyState()
        delegate?.didUpdateFavorites()
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }
    
    func didDeleteCategory(at index: Int) {
        guard index < favoriteCategories.count else { return }
        removeFromFavorites(at: index)
    }
    
    // MARK: - UI Components
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No favorites yet"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var favoriteCategories: [CategoryCardModel]
    var router: Router
    weak var delegate: FavoritesUpdateDelegate?
    
    // MARK: - Initializer
    init(router: Router, favorites: [CategoryCardModel]) {
        self.router = router
        self.favoriteCategories = favorites
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
                                             selector: #selector(handleCategoryUpdated(_:)),
                                             name: .categoryUpdated,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleCategoryDeleted(_:)),
                                             name: .categoryDeleted,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleFavoritesUpdated),
                                             name: .favoritesUpdated,
                                             object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    private func setup() {
        title = "Favorites"
        view.addSubview(collectionView)
        view.addSubview(emptyStateLabel)
        view.addSubview(imageView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Notification Handlers
    @objc private func handleCategoryUpdated(_ notification: Notification) {
        if let category = notification.userInfo?["category"] as? CategoryCardModel,
           let index = notification.userInfo?["index"] as? Int,
           index < favoriteCategories.count,
           favoriteCategories.contains(where: { $0.id == category.id }) {
            favoriteCategories[index] = category
            collectionView.reloadData()
            checkEmptyState()
        }
    }
    
    @objc private func handleCategoryDeleted(_ notification: Notification) {
        if let index = notification.userInfo?["index"] as? Int,
           index < favoriteCategories.count {
            removeFromFavorites(at: index)
        }
    }
    
    @objc private func handleFavoritesUpdated() {
        // Refresh favorites from source (e.g., CategoriesViewModel or UserDefaultsManager)
        favoriteCategories = CategoriesViewModel().getFavoriteCategories()
        collectionView.reloadData()
        checkEmptyState()
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
        emptyStateLabel.isHidden = !favoriteCategories.isEmpty
        imageView.isHidden = !favoriteCategories.isEmpty
        title = favoriteCategories.isEmpty ? "No favorites" : "Favorites"
    }
    
    private func removeFromFavorites(at index: Int) {
        guard index >= 0 && index < favoriteCategories.count else { return }
        
        let id = favoriteCategories[index].id
        UserDefaultsManager.shared.removeFavorite(id: id)
        favoriteCategories.remove(at: index)
        collectionView.reloadData()
        checkEmptyState()
        delegate?.didUpdateFavorites()
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }
}

// MARK: - UICollectionViewDelegate & DataSource & FlowLayout
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCardCell", for: indexPath) as? CategoryCardCell else {
            return UICollectionViewCell()
        }
        
        let item = favoriteCategories[indexPath.row]
        cell.model = item
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedModel = favoriteCategories[indexPath.row]
        router.navigateToCategoryDetail(with: selectedModel)
    }
}
