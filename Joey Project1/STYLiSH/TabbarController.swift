//
//  TabbarController.swift
//  STYLiSH
//
//  Created by 池昀哲 on 2024/8/9.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("選中了Tab: \(viewController)")
    }
}
