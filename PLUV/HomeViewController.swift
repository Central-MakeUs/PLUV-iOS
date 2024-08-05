//
//  HomeViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/9/24.
//

import UIKit
import SnapKit
import Then

class HomeViewController: UIViewController {
    
    private let transferDirectButton = UIButton().then {
        $0.titleLabel?.text = "직접 옮기기"
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .systemGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
}

extension HomeViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(transferDirectButton)
        transferDirectButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        transferDirectButton.addTarget(self, action: #selector(clickTransferDirectButton), for: .touchUpInside)
    }
    
    @objc private func clickTransferDirectButton() {
        let transferSourceViewController = TransferSourceViewController()
        self.navigationController?.pushViewController(transferSourceViewController, animated: true)
    }
}
