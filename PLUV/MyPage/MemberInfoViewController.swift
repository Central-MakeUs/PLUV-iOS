//
//  MemberInfoViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit

class MemberInfoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
    }
    
    private func setNavigationBar() {
        /// NavigationBar의 back 버튼 이미지 변경
        let backImage = UIImage(named: "backbutton_icon")?.withRenderingMode(.alwaysOriginal)
        let resizedBackImage = backImage?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 24, height: 24))
        let backButton = UIBarButtonItem(image: resizedBackImage, style: .plain, target: self, action: #selector(clickBackButton))
        backButton.tintColor = .gray800
        navigationItem.leftBarButtonItem = backButton
        
        /// 커스터마이즈된 제목 뷰 추가
        let titleLabel = UILabel()
        titleLabel.text = "회원 정보"
        titleLabel.textColor = UIColor.gray800
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc private func clickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
