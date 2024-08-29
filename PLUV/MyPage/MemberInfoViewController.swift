//
//  MemberInfoViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit

class MemberInfoViewController: UIViewController {
    
    private let nickNameView = UIView()
    private let nickNameTitleLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14)
    }
    private let nickNameLabel = UILabel().then {
        $0.text = "플러버"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let separatorView = UIView().then {
        $0.backgroundColor = .gray200
    }
    private let deleteAccountView = UIView()
    private let deleteAccountLabel = UILabel().then {
        $0.text = "회원 탈퇴"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
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
        
        self.view.addSubview(nickNameView)
        nickNameView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(114)
        }
        
        self.nickNameView.addSubview(nickNameTitleLabel)
        nickNameTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        self.nickNameView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
        
        self.view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(nickNameView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.view.addSubview(deleteAccountView)
        deleteAccountView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        self.deleteAccountView.addSubview(deleteAccountLabel)
        deleteAccountLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
    }
    
    @objc private func clickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
