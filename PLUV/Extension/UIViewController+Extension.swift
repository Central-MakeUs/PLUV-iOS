//
//  UIViewController+Extension.swift
//  PLUV
//
//  Created by 백유정 on 8/8/24.
//

import UIKit

extension UIViewController {
    
    func findPresentViewController() -> UIViewController {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let keyWindow = windowScene.windows.first
        assert((keyWindow != nil), "keyWindow is empty")
        
        var presentViewController = keyWindow?.rootViewController

        while true {
           while let presentedViewController = presentViewController?.presentedViewController {
               presentViewController = presentedViewController
           }
           if let navigationController = presentViewController as? UINavigationController {
               presentViewController = navigationController.visibleViewController
               continue
           }
           if let tabBarController = presentViewController as? UITabBarController {
               presentViewController = tabBarController.selectedViewController
               continue
           }
           break
        }
        
        guard let presentViewController = presentViewController else {
            return UIViewController()
        }
        
        return presentViewController
    }
}
