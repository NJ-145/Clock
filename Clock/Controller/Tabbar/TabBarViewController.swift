//
//  TabBarViewController.swift
//  Clock
//
//  Created by imac-2626 on 2024/10/1.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.selectedIndex = 1
        self.delegate = self
    }
    
    // MARK: - UI Settings
    
    func setupTabs() {
        let worldClockVC = WorldViewController()
        let clockVC = MainViewController()
        let stopWatchVC = StopWatchViewController()
        let timerVC = TimerViewController()
        
        // 使用 createNav 包裝每個 VC
        let worldNav = createNav(whit: "世界時鐘", and: UIImage(systemName: "globe"), vc: worldClockVC)
        let clockNav = createNav(whit: "鬧鐘", and: UIImage(systemName: "alarm.fill"), vc: clockVC)
        let stopWatchNav = createNav(whit: "碼錶", and: UIImage(systemName: "stopwatch"), vc: stopWatchVC)
        let timerNav = createNav(whit: "計時器", and: UIImage(systemName: "timer"), vc: timerVC)
        
        self.tabBar.barTintColor = .clear
        self.tabBar.tintColor = .orange
        self.setViewControllers([worldNav, clockNav, stopWatchNav, timerNav], animated: false)
        self.tabBar.backgroundColor = .secondarySystemBackground
    }

    // MARK: - IBAction
    
    // MARK: - Function
    private func createNav(whit title: String, and image:UIImage?, vc:UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }

}
// MARK: - Extensions

