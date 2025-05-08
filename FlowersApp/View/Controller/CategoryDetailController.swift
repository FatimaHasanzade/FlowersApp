//
//  CategoryDetailController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 05.05.25.
//

import UIKit

class CategoryDetailController: UIViewController {
    
    // MARK: - Properties
    private let detailView = DetailView()
    private let model: CategoryCardModel

    var router: Router
    
    // MARK: - Initializer
    init(router: Router, model: CategoryCardModel) {
        self.model = model
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        setupNavigationController()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setup(){
        view.addSubview(detailView)
    }
    
    // MARK: - Layout Methods
    private func layout(){
        detailView.pinToEdges(of: view)
    }

    // MARK: - Navigation Methods
    private func setupNavigationController() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    // MARK: - Binding Methods
    private func bind() {
        detailView.labelTitle.text = model.title
        detailView.imageView.image = model.image
        
        print("image: \(model.image)")
    }
    
        

}
