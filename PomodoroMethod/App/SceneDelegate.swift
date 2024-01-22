//
//  SceneDelegate.swift
//  PomodoroMethod
//
//  Created by Churkin Vitaly on 22.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let pomodoroViewController = PomodoroViewController()
        window?.rootViewController = pomodoroViewController
        window?.makeKeyAndVisible()
    }
}

