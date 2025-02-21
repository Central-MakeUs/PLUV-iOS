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
    
    func convertImageToBase64(image: UIImage, format: String = "png") -> String? {
        // UIImage를 Data로 변환
        let imageData: Data?
        
        if format.lowercased() == "png" {
            imageData = image.pngData()
        } else if format.lowercased() == "jpeg" || format.lowercased() == "jpg" {
            imageData = image.jpegData(compressionQuality: 1.0) // 압축 품질: 1.0 (최고 품질)
        } else {
            print("Unsupported format: \(format)")
            return nil
        }
        
        // Data를 Base64 문자열로 변환
        guard let data = imageData else {
            print("Failed to convert UIImage to Data")
            return nil
        }
        return data.base64EncodedString()
    }
}
