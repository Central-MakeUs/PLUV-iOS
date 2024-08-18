//
//  SceneDelegate.swift
//  PLUV
//
//  Created by 백유정 on 7/9/24.
//

import UIKit
import SpotifyiOS

/*
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window = UIWindow(windowScene: windowScene)
        let homeVC = UINavigationController(rootViewController: TransferDestinationViewController())
        window?.rootViewController = homeVC
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
*/
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var LoginVC = UINavigationController(rootViewController: MovePlaylistViewController())
    lazy var SpotifyVC = ViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .light
        window!.rootViewController = LoginVC
    }

    // For spotify authorization and authentication flow
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        let parameters = SpotifyVC.appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            SpotifyVC.responseCode = code
        } else if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            SpotifyVC.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", error_description)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let accessToken = SpotifyVC.appRemote.connectionParameters.accessToken {
            SpotifyVC.appRemote.connectionParameters.accessToken = accessToken
            SpotifyVC.appRemote.connect()
        } else if let accessToken = SpotifyVC.accessToken {
            SpotifyVC.appRemote.connectionParameters.accessToken = accessToken
            SpotifyVC.appRemote.connect()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if SpotifyVC.appRemote.isConnected {
            SpotifyVC.appRemote.disconnect()
        }
    }
}
