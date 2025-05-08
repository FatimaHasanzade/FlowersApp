//
//  TabBarController.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 05.05.25.
//
import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    var router: Router

    // MARK: - Initializer
    init(router: Router) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    // MARK: - Private Methods
    private func configureTabBar() {
        let vc1 = CategoriesViewController(router: router)
        let nav1 = UINavigationController(rootViewController: vc1)

        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemGray6
        self.title = nil
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        setViewControllers([nav1], animated: true)
    }
}
