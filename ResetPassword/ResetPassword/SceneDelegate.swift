//
//  SceneDelegate.swift
//  ResetPassword
//
//  Created by Mar Cabrera on 13/09/2022.
//

import UIKit
import RealmSwift

let app = App(id: "")

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Universal Links Handling
        
        guard let userActivity = connectionOptions.userActivities.first, userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                let incomingURL = userActivity.webpageURL else {
            // If we don't get a link (meaning it's not handling the reset password flow then we have to check if user is logged in)
            if let _ = app.currentUser {
                // We make sure that the session is being kept active for users that have previously logged in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewController(identifier: "MainViewController")

                window?.rootViewController = mainVC
                window?.makeKeyAndVisible()
            }
            return
        }

        handleUniversalLinks(incomingURL)
    }
    
    /**
     This delegate method gets triggered whenever user taps on link from email and app has not been terminated
     */
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {

        if let url = userActivity.webpageURL {
            handleUniversalLinks(url)
        }
    }

    
    private func handleUniversalLinks(_ url: URL) {
        // We get the token and tokenId URL parameters, they're necessary in order to reset password
        let token = url.valueOf("token")
        let tokenId = url.valueOf("tokenId")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resetPasswordViewController = storyboard.instantiateViewController(identifier: "ResetPasswordViewController") as! ResetPasswordViewController
        // We might not need a navigation controller
        let navigationController = UINavigationController(rootViewController: resetPasswordViewController)
        resetPasswordViewController.token = token
        resetPasswordViewController.tokenId = tokenId

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension URL {
    // Function that returns a specific query parameter from the URL
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }

        return url.queryItems?.first(where: {$0.name == queryParameterName})?.value
    }
}

