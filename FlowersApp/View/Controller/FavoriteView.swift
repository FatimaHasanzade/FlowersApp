//
//  FavoriteView.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 06.05.25.
//

// FavoriteView.swift
import UIKit

class FavoriteView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCardCell.self, forCellWithReuseIdentifier: "CategoryCardCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}

extension FavoriteView {
    private func setupView() {
        addSubViews(titleLabel, collectionView)
    }
    
    private func style() {
        backgroundColor = .white
    }
    
    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
        ])
    }
}
