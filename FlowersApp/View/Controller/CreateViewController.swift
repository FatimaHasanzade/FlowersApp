//
//  CreateViewController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 05.05.25.
//

import UIKit
import SnapKit

class CreateViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: CreateViewControllerDelegate?
    private let router: Router
    private var category: CategoryCardModel?
    private var categoryIndex: Int?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter flower title"
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = UIConstants.cornerRadius
        textField.layer.masksToBounds = true
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.accessibilityLabel = "Flower title input"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let previewView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = UIConstants.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let colorPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pick Color", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemGray5
        button.applyShadow()
        button.accessibilityLabel = "Pick a color for the category"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pick Image", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemGray5
        button.applyShadow()
        button.accessibilityLabel = "Pick an image for the category"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.applyShadow()
        button.accessibilityLabel = "Save the category"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.applyShadow()
        button.accessibilityLabel = "Delete the category"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedColor: UIColor = .white
    private var selectedImage: UIImage?
    
    // MARK: - Initializers
    init(router: Router, category: CategoryCardModel? = nil, index: Int? = nil) {
        self.router = router
        self.category = category
        self.categoryIndex = index
        
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        layout()
        setupNavigationController()
        configureForMode()
        updateSaveButtonState()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            [self.titleTextField, self.previewView, self.colorPickerButton, self.imagePickerButton, self.saveButton, self.deleteButton].forEach { view in
                view.alpha = 1
            }
        }
    }
    
    // MARK: - Setup Methods
    private func setup() {
        view.addSubViews(titleTextField,previewView,colorPickerButton,imagePickerButton,saveButton,deleteButton)
        previewView.addSubview(previewImageView)
        
        titleTextField.delegate = self
        colorPickerButton.addTarget(self, action: #selector(pickColor), for: .touchUpInside)
        imagePickerButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveCategory), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteCategory), for: .touchUpInside)
        
        colorPickerButton.addTapAnimation()
        imagePickerButton.addTapAnimation()
        saveButton.addTapAnimation()
        deleteButton.addTapAnimation()
        
        [titleTextField, previewView, colorPickerButton, imagePickerButton, saveButton, deleteButton].forEach { view in
            view.alpha = 0
        }
    }
    
    private func layout() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UIConstants.spacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.margin)
            make.height.equalTo(UIConstants.buttonHeight)
        }
        
        previewView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(UIConstants.spacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.margin)
            make.height.equalTo(100)
        }
        
        previewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        colorPickerButton.snp.makeConstraints { make in
            make.top.equalTo(previewView.snp.bottom).offset(UIConstants.spacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.margin)
            make.height.equalTo(UIConstants.buttonHeight)
        }
        
        imagePickerButton.snp.makeConstraints { make in
            make.top.equalTo(colorPickerButton.snp.bottom).offset(UIConstants.spacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.margin)
            make.height.equalTo(UIConstants.buttonHeight)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(imagePickerButton.snp.bottom).offset(UIConstants.spacing * 1.5)
            make.leading.trailing.equalToSuperview().inset(UIConstants.margin)
            make.height.equalTo(UIConstants.buttonHeight)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(UIConstants.spacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.margin)
            make.height.equalTo(UIConstants.buttonHeight)
        }
    }
    
    private func setupNavigationController() {
        title = category == nil ? "Create" : "Edit"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)
        ]
    }
    
    private func configureForMode() {
        if let category = category {
            titleTextField.text = category.title
            selectedColor = category.color
            selectedImage = category.image
            colorPickerButton.backgroundColor = category.color
            imagePickerButton.setTitle("Image Selected", for: .normal)
            previewView.backgroundColor = category.color.withAlphaComponent(0.2)
            previewImageView.image = category.image
            saveButton.setTitle("Update", for: .normal)
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = !(titleTextField.text?.isEmpty ?? true) && selectedImage != nil
        saveButton.backgroundColor = saveButton.isEnabled ? .systemBlue : .systemGray3
    }
    
    private func resetForm() {
        titleTextField.text = ""
        selectedColor = .white
        selectedImage = nil
        colorPickerButton.backgroundColor = .systemGray5
        imagePickerButton.setTitle("Pick Image", for: .normal)
        previewView.backgroundColor = .systemGray6
        previewImageView.image = nil
        updateSaveButtonState()
    }
    
    private func showSuccessAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteConfirmationAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete this category?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion()
        })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func pickColor() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        present(colorPicker, animated: true, completion: nil)
    }
    
    @objc private func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func saveCategory() {
        guard let title = titleTextField.text, !title.isEmpty, let selectedImage = selectedImage else {
            return
        }
        
        let categoryModel = CategoryCardModel(
            title: title,
            image: selectedImage,
            color: selectedColor,
            borderColor: selectedColor.withAlphaComponent(0.5),
            isFavorite: category?.isFavorite ?? false,
            isUserCreated: true
        )
        
        if let index = categoryIndex {
            delegate?.didUpdateCategory(categoryModel, at: index)
            UserDefaultsManager.shared.updateCategory(categoryModel, at: categoryModel.id)
            NotificationCenter.default.post(name: .categoryUpdated, object: nil, userInfo: ["category": categoryModel, "index": index])
            showSuccessAlert(message: "Category successfully updated!") {
                self.resetForm()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            delegate?.didCreateNewCategory(categoryModel)
            UserDefaultsManager.shared.saveCategory(categoryModel)
            NotificationCenter.default.post(name: .newCategoryCreated, object: nil, userInfo: ["category": categoryModel])
            showSuccessAlert(message: "Category successfully created!") {
                self.resetForm()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func deleteCategory() {
        guard let category = category else {
            return
        }
        let categoryId = category.id
       
        showDeleteConfirmationAlert {
            self.delegate?.didDeleteCategory(at: categoryId)
            UserDefaultsManager.shared.deleteCategory(at: categoryId)
            NotificationCenter.default.post(name: .categoryDeleted, object: nil, userInfo: ["id": categoryId])
            self.showSuccessAlert(message: "Category successfully deleted!") {
                self.resetForm()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension CreateViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorPickerButton.backgroundColor = selectedColor
        previewView.backgroundColor = selectedColor.withAlphaComponent(0.2)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            previewImageView.image = image
            imagePickerButton.setTitle("Image Selected", for: .normal)
            updateSaveButtonState()
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension CreateViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateSaveButtonState()
    }
}

// MARK: - UIButton Tap Animation
extension UIButton {
    func addTapAnimation() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    @objc private func animateDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func animateUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}
