//
//  SceneDelegate.swift
//  MoneyManagerDemo
//
//  Created by Julien on 28/10/21.
//

import UIKit
import GoogleSignIn


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    static var shared: SceneDelegate!
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        SceneDelegate.shared=self
//        let mainStoryBoard = UIStoryboard(name: "WelcomeScreen", bundle: nil)
//        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "WelcomeScreen")
//        window?.rootViewController = viewController
        if( !UserDefaults.standard.bool(forKey: "isOnBoardingShown")){
            //if onboarding screen not shown
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "Main")
            window?.rootViewController = viewController
        }
        else{
            //if onboarding screen is shown
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error != nil || user == nil {
                    print("Signed Out")
                    if let viewController = UIStoryboard(name: "WelcomeScreen", bundle: nil).instantiateViewController(withIdentifier: "WelcomeScreen") as? WelcomeScreenViewController {
                        let navController = UINavigationController(rootViewController: viewController)
                        self.window?.rootViewController = navController
                    }
                } else {
                    // Show the app's signed-in state.
                    print("Signed In")
                    if let viewController = UIStoryboard(name: "MoneyManagerDashboard", bundle: nil).instantiateViewController(withIdentifier: "DashBoard") as? DashBoardViewController {
                        let navController = UINavigationController(rootViewController: viewController)
                        self.window?.rootViewController = navController
                    }

                    }
                }
            
        }
        
        

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

