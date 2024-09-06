//
//  ValidationNotFoundViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/27/24.
//

import UIKit

class ValidationNotFoundViewController: UIViewController {
    
    private let titleView = UIView()
    private let titleLabel = UILabel()
    private let subLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
}
