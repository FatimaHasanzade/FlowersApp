//
//  CategoriesView.swift
//  FlowersApp
//
//  Created by Fatime on 04.05.25.
//

import UIKit
import SnapKit

class CategoriesView: UIView {
    
    
    // MARK: - UI Components
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search Here...",
            attributes: [.foregroundColor: UIColor.gray]
        )
        if let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate) {
            searchBar.setImage(image, for: .search, state: .normal)
            searchBar.searchTextField.leftView?.tintColor = .systemGray
        }
        return searchBar
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
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        style()
        layout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
}

// MARK: - Setup Methods
extension CategoriesView {
    private func setupView(){
       addSubViews(searchBar,collectionView)
        
    }
    
    private func style(){
        backgroundColor = .white
    }
    
    private func layout(){
              searchBar.snp.makeConstraints { make in
                   make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
                   make.leading.equalToSuperview().offset(20)
                   make.trailing.equalToSuperview().inset(20)
               }

               collectionView.snp.makeConstraints { make in
                   make.top.equalTo(searchBar.snp.bottom).offset(16)
                   make.leading.equalToSuperview().offset(24)
                   make.trailing.equalToSuperview().inset(24)
                   make.bottom.equalToSuperview().offset(8)
               }
    }
    
}
