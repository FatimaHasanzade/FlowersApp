//
//  CategoriesViewController.swift
//  FlowersApp
//
//  Created by Fatime on 04.05.25.
//

import UIKit
import SnapKit


class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    var selectedCategory: CategoryCardModel?
    private let categoriesView = CategoriesView()
    private var viewModel = CategoriesViewModel()
    private var filteredCategories: [CategoryCardModel] = []
    var router: Router
    
    // MARK: - Initializers
    init(router: Router) {
        self.router = router
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
        setupNavigationController()
        filteredCategories = viewModel.categoriesList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateFavoriteStatus()
        categoriesView.collectionView.reloadData()
    }
    
    // MARK: - Setup Methods
    private func setup(){
        view.addSubview(categoriesView)
        categoriesView.collectionView.delegate = self
        categoriesView.collectionView.dataSource = self
        
        // Add favorites button to navigation bar
        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showFavorites))
        navigationItem.rightBarButtonItem = favoritesButton
        
        categoriesView.searchBar.delegate = self
    }
    
    @objc private func showFavorites() {
        router.navigateToFavorites(with: viewModel.getFavoriteCategories())
    }
    
    private func layout(){
        categoriesView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
        }
    }

    private func setupNavigationController() {
        title = "Find Flowers"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationItem.setHidesBackButton(true, animated: false)
    }
}

// MARK: - UISearchBarDelegate
extension CategoriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If search text is empty, show all categories
            filteredCategories = viewModel.categoriesList
        } else {
            // Filter categories based on search text
            filteredCategories = viewModel.categoriesList.filter { category in
                category.title.lowercased().contains(searchText.lowercased())
            }
        }
        categoriesView.collectionView.reloadData()
    }
}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCardCell", for: indexPath) as? CategoryCardCell else { return UICollectionViewCell() }
        
        let item = filteredCategories[indexPath.row]
        cell.model = item
        
        cell.onHeartTap = { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.toggleFavorite(at: indexPath.row)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedModel = viewModel.categoriesList[indexPath.row]
        router.navigateToCategoryDetail(with: selectedModel)
    }
}


class CategoryCardCell : UICollectionViewCell {
    
    // MARK: - Properties
    var onHeartTap: ((Bool) -> Void)?
    
    var model: CategoryCardModel? {
        didSet {
            bind()
        }
    }
    
   
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 16,weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.distribution = .fill
        return stack
    }()
        
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        style()
        layout()
        heartButton.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Overrides
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    override func prepareForReuse() {
           super.prepareForReuse()
           heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }

    // MARK: - Actions
    @objc private func didTapHeart() {
           let isFavorited = heartButton.currentImage == UIImage(systemName: "heart.fill")
           let newIsFavorited = !isFavorited
           setFavorite(isFavorite: newIsFavorited)
           onHeartTap?(newIsFavorited)
    }
    
    func setFavorite(isFavorite: Bool) {
            let image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
            heartButton.setImage(image, for: .normal)
    }

}
extension CategoryCardCell {
    
    // MARK: - Setup & Binding
    private func setupView(){
        contentView.addSubview(stackView)
        contentView.addSubview(heartButton)
    }
    
    private func style(){
        layer.cornerRadius = 12
        layer.borderWidth = 2
     
    }
    
    private func layout() {
        stackView.snp.makeConstraints { make in
                   make.edges.equalToSuperview().inset(8)
               }

               imageView.snp.makeConstraints { make in
                   make.height.equalTo(110)
                   make.width.equalToSuperview()
               }

               heartButton.snp.makeConstraints { make in
                   make.trailing.equalToSuperview().inset(8)
                   make.top.equalTo(imageView.snp.bottom).offset(8)
                   make.size.equalTo(CGSize(width: 24, height: 24))
               }

               titleLabel.snp.makeConstraints { make in
                   make.leading.trailing.equalToSuperview().inset(8)
                   make.top.equalTo(heartButton.snp.bottom).offset(4) 
               }
    }
    
    func bind(){
        guard let model = model else {return}
        imageView.image = model.image
        titleLabel.text = model.title
        backgroundColor = model.color
        layer.borderColor = model.borderColor.cgColor
        setFavorite(isFavorite: model.isFavorite)
    }
}
