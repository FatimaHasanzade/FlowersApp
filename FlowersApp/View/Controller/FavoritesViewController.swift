//
//  FavoritesViewController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 05.05.25.
//
import UIKit
import SnapKit

class FavoritesViewController: UIViewController {
    
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
    
    private let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.contentMode = .scaleAspectFit
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
    }
    
    // MARK: - Setup Methods
    private func setup() {
        title = "Favorites"
        view.addSubViews(collectionView,emptyStateLabel,ImageView)
        
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
    
    // MARK: - Layout
    private func layout() {
        collectionView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.leading.trailing.bottom.equalToSuperview()
            }
        ImageView.snp.makeConstraints{ make in
                make.center.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(100)
            }
        emptyStateLabel.snp.makeConstraints { make in
                make.top.equalTo(ImageView.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
            
    }
    
    // MARK: - Helper Methods
    private func checkEmptyState() {
        emptyStateLabel.isHidden = !favoriteCategories.isEmpty
        ImageView.isHidden = !favoriteCategories.isEmpty
    }
    
    func removeFromFavorites(at index: Int) {
        guard index >= 0 && index < favoriteCategories.count else {
            print("Warning: Attempted to remove favorite at invalid index: \(index)")
            return
        }

        let id = favoriteCategories[index].id

        UserDefaultsManager.shared.removeFavorite(id: id)

        favoriteCategories.remove(at: index)

        collectionView.reloadData()

        checkEmptyState()

        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }

}

// MARK: - UICollectionViewDelegate & DataSource & FlowLayout
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCardCell", for: indexPath) as? CategoryCardCell else { return UICollectionViewCell() }
        
        let item = favoriteCategories[indexPath.row]
        cell.model = item
        
        cell.onHeartTap = { [weak self] isFavorited in
            guard let self = self, !isFavorited else { return }
            self.removeFromFavorites(at: indexPath.row)
        }
        
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
