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
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let vc3 = CartViewController(router: router)
        let nav3 = UINavigationController(rootViewController: vc3)
        nav3.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), tag: 2)
        
        let vc2 = CreateViewController(router: router)
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus.circle"), tag: 1)

        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemGray6

        setViewControllers([nav1, nav2, nav3], animated: false)
    }
}
