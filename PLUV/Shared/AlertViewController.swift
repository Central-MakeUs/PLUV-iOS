//
//  AlertViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/8/24.
//

import UIKit

final class AlertController {
    
    var alertController: UIAlertController
    
    init(message: String, completion: @escaping () -> () = {}) {
        alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { alert in
            completion()
        }
        alertController.addAction(okAction)
    }
    
    func show() {
        let presentVC = UIViewController().findPresentViewController()
        presentVC.present(alertController, animated: true, completion: nil)
    }
}
