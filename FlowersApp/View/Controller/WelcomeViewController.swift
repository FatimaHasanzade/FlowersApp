//
//  ViewController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 03.05.25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    private let welcomeView = WelcomeView()
    var router: Router!
    
    // MARK: - Initializer
    init(router: Router!) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        setupBindings()
    }
    
    // MARK: - Setup Methods
    private func setup(){
        view.addSubview(welcomeView)
        
        welcomeView.didTapStart = { [weak self] in
            guard let self = self else {return}
            self.router.pushCategoriesViewController()
        }
    }
    
    // MARK: - Layout Methods
    private func layout(){
        welcomeView.pinToEdges(of: view)
    }
    
    // MARK: - Binding Methods
    private func setupBindings() {
           welcomeView.didTapStart = { [weak self] in
               guard let self = self else { return }
               let tabBarController = TabBarController(router: self.router)
               self.router.navigation.setViewControllers([tabBarController], animated: true)
           }
       }

}
