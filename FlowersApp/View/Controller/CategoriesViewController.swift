//
//  CategoriesViewController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 03.05.25.
//
import UIKit
import SnapKit



class CategoriesViewController: UIViewController, CategoryCardCellDelegate, FavoritesUpdateDelegate, CreateViewControllerDelegate {
    
    // MARK: - Delegate Methods
    func didTapHeart(on cell: CategoryCardCell) {
        guard let indexPath = categoriesView.collectionView.indexPath(for: cell) else { return }
        let category = filteredCategories[indexPath.row]
        print("Before toggle>>>>> \(category.isFavorite)")
        
        // Toggle favorite status in viewModel using category ID
        viewModel.toggleFavorite(categoryId: category.id)
        
        // Update filteredCategories to reflect the change
        if let index = filteredCategories.firstIndex(where: { $0.id == category.id }) {
            filteredCategories[index].isFavorite = viewModel.categoriesList.first(where: { $0.id == category.id })?.isFavorite ?? filteredCategories[index].isFavorite
        }
        
        print("After toggle>>>>>> \(filteredCategories[indexPath.row].isFavorite)")
        categoriesView.collectionView.reloadItems(at: [indexPath])
    }
    
    func didTapAddToCart(on cell: CategoryCardCell) {
        guard let indexPath = categoriesView.collectionView.indexPath(for: cell) else { return }
        let item = filteredCategories[indexPath.row]
        
        if CartManager.shared.isInCart(id: item.id) {
            CartManager.shared.removeFromCart(id: item.id)
            cell.setCartStatus(isInCart: false)
            
            let alert = UIAlertController(title: "Uğurlu", message: "\(item.title) səbətdən çıxarıldı!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            CartManager.shared.addToCart(item: item)
            cell.setCartStatus(isInCart: true)
            
            let alert = UIAlertController(title: "Uğurlu", message: "\(item.title) səbətə əlavə edildi!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func didTapDelete(on cell: CategoryCardCell) {
        guard let indexPath = categoriesView.collectionView.indexPath(for: cell) else { return }
        let category = filteredCategories[indexPath.row]
        let alert = UIAlertController(title: "Sil", message: "Bu kateqoriyanı silmək istədiyinizə əminsiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ləğv et", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { _ in
            print("Attempting to delete category: \(category.title), ID: \(category.id)")
            self.viewModel.deleteCategory(withId: category.id)
            self.filteredCategories = self.viewModel.categoriesList
            self.categoriesView.collectionView.reloadData()
            NotificationCenter.default.post(name: .categoryDeleted, object: nil, userInfo: ["id": category.id])
        })
        present(alert, animated: true, completion: nil)
    }
    
    func didTapUpdate(on cell: CategoryCardCell) {
        guard let indexPath = categoriesView.collectionView.indexPath(for: cell) else { return }
        let selectedModel = filteredCategories[indexPath.row]
        let createVC = CreateViewController(router: router, category: selectedModel, index: indexPath.row)
        createVC.delegate = self
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    func didCreateNewCategory(_ category: CategoryCardModel) {
        viewModel.addCategory(category)
        filteredCategories = viewModel.categoriesList
        categoriesView.collectionView.reloadData()
    }
    
    func didUpdateCategory(_ category: CategoryCardModel, at index: Int) {
        viewModel.updateCategory(category, at: index)
        filteredCategories = viewModel.categoriesList
        categoriesView.collectionView.reloadData()
    }
    
    func didDeleteCategory(at id: Int) {
        print("Delegate: Received delete request for category ID: \(id)")
        viewModel.deleteCategory(withId: id)
        filteredCategories = viewModel.categoriesList
        categoriesView.collectionView.reloadData()
    }
    
    func didUpdateFavorites() {
        viewModel.updateFavoriteStatus()
        filteredCategories = viewModel.categoriesList
        categoriesView.collectionView.reloadData()
    }
    
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
        
        // Notification dinlə
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleNewCategory(_:)),
                                             name: .newCategoryCreated,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleUpdatedCategory(_:)),
                                             name: .categoryUpdated,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleDeletedCategory(_:)),
                                             name: .categoryDeleted,
                                             object: nil)
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleNewCategory(_ notification: Notification) {
        if let category = notification.userInfo?["category"] as? CategoryCardModel {
            viewModel.addCategory(category)
            filteredCategories = viewModel.categoriesList
            categoriesView.collectionView.reloadData()
        }
    }
    
    @objc private func handleUpdatedCategory(_ notification: Notification) {
        if let category = notification.userInfo?["category"] as? CategoryCardModel,
           let index = notification.userInfo?["index"] as? Int {
            viewModel.updateCategory(category, at: index)
            filteredCategories = viewModel.categoriesList
            categoriesView.collectionView.reloadData()
        }
    }
    
    @objc private func handleDeletedCategory(_ notification: Notification) {
        if let id = notification.userInfo?["id"] as? Int {
            print("Received categoryDeleted notification for ID: \(id)")
            viewModel.deleteCategory(withId: id)
            filteredCategories = viewModel.categoriesList
            categoriesView.collectionView.reloadData()
        } else {
            print("Invalid or missing ID in categoryDeleted notification")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateFavoriteStatus()
        filteredCategories = viewModel.categoriesList
        categoriesView.collectionView.reloadData()
    }
    
    // MARK: - Setup Methods
    private func setup() {
        view.addSubview(categoriesView)
        categoriesView.collectionView.delegate = self
        categoriesView.collectionView.dataSource = self
        

        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showFavorites))

        navigationItem.rightBarButtonItems = [favoritesButton]
        
        categoriesView.searchBar.delegate = self
    }
    
    @objc private func showFavorites() {
        let favoritesVC = FavoritesViewController(router: router, favorites: viewModel.getFavoriteCategories())
        favoritesVC.delegate = self
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    

    
    private func layout() {
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
        filteredCategories = viewModel.searchCategories(with: searchText)
        categoriesView.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCardCell", for: indexPath) as? CategoryCardCell else { return UICollectionViewCell() }
        
        let item = filteredCategories[indexPath.row]
        cell.model = item
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedModel = filteredCategories[indexPath.row]
        let detailVC = CategoryDetailController(router: router, model: selectedModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class CategoryCardCell: UICollectionViewCell {
    
    weak var delegate: CategoryCardCellDelegate?
    
    var model: CategoryCardModel? {
        didSet {
            bind()
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
    
    private let cartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "cart")
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "trash")
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .blue
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        style()
        layout()
        heartButton.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(didTapCart), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(didTapUpdate), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        updateButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        deleteButton.isHidden = false
        updateButton.isHidden = false
    }
    
    @objc private func didTapHeart() {
        let isFavorited = heartButton.currentImage == UIImage(systemName: "heart.fill")
        let newIsFavorited = !isFavorited
        setFavorite(isFavorite: newIsFavorited)
        delegate?.didTapHeart(on: self)
    }
    
    @objc private func didTapCart() {
        let isInCart = cartButton.currentImage == UIImage(systemName: "cart.fill")
        setCartStatus(isInCart: !isInCart)
        delegate?.didTapAddToCart(on: self)
    }
    
    @objc private func didTapDelete() {
        delegate?.didTapDelete(on: self)
    }
    
    @objc private func didTapUpdate() {
        delegate?.didTapUpdate(on: self)
    }
    
    func setFavorite(isFavorite: Bool) {
        let image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        heartButton.setImage(image, for: .normal)
    }
    
    func setCartStatus(isInCart: Bool) {
        let image = UIImage(systemName: isInCart ? "cart.fill" : "cart")
        cartButton.setImage(image, for: .normal)
    }
    
    // MARK: - Setup & Binding
    private func setupView() {
        contentView.addSubview(stackView)
        contentView.addSubview(heartButton)
        contentView.addSubview(cartButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(updateButton)
    }
    
    private func style() {
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
        
        cartButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(heartButton.snp.leading).offset(-8)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        updateButton.snp.makeConstraints { make in
            make.leading.equalTo(cartButton.snp.trailing).offset(8)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(heartButton.snp.bottom).offset(4)
        }
    }
    
    func bind() {
        guard let model = model else { return }
        imageView.image = model.image
        titleLabel.text = model.title
        backgroundColor = model.color
        layer.borderColor = model.borderColor.cgColor
        setFavorite(isFavorite: model.isFavorite)
        let isInCart = CartManager.shared.isInCart(id: model.id)
        setCartStatus(isInCart: isInCart)
        
        deleteButton.isHidden = !model.isUserCreated
        updateButton.isHidden = !model.isUserCreated
    }
}
