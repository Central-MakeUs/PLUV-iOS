//
//  DeleteAccountViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit

class DeleteAccountViewController: UIViewController {
    
    private let deleteAccountView = UIView()
    private let deleteAccountTitleLabel = UILabel().then {
        $0.text = "PLUV을 정말 탈퇴하시나요? 🥲"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let deleteAccountSubLabel = UILabel().then {
        $0.text = "계정 삭제 시, 회원 정보와 모든 이용 내역(내 플레이리스트 및 저장한 플레이리스트)이 삭제되며 복구가 불가능합니다."
        $0.numberOfLines = 0
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 16)
    }
    private let checkView = UIView()
    private let checkBoxButton = UIButton().then {
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.backgroundColor = .white
    }
    private let checkLabel = UILabel().then {
        $0.text = "위 사항을 모두 확인했으며, 이에 동의합니다."
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    private let deleteAccountButton = BlackButton()
    
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
        titleLabel.text = "회원 탈퇴하기"
        titleLabel.textColor = UIColor.gray800
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(deleteAccountView)
        deleteAccountView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        self.deleteAccountView.addSubview(deleteAccountTitleLabel)
        deleteAccountTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(28)
        }
        
        self.deleteAccountView.addSubview(deleteAccountSubLabel)
        deleteAccountSubLabel.snp.makeConstraints { make in
            make.top.equalTo(deleteAccountTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
            make.height.equalTo(66)
        }
        
        self.view.addSubview(checkView)
        checkView.snp.makeConstraints { make in
            make.top.equalTo(deleteAccountView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        self.checkView.addSubview(checkBoxButton)
        checkBoxButton.addTarget(self, action: #selector(clickCheckBoxButton(_:)), for: .touchUpInside)
        checkBoxButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(24)
            make.width.height.equalTo(24)
        }
        
        self.checkView.addSubview(checkLabel)
        checkLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkBoxButton.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        
        self.view.addSubview(deleteAccountButton)
        deleteAccountButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(40+49)
            make.height.equalTo(48)
        }
        
        deleteAccountButton.isEnabled = false
        deleteAccountButton.setTitle("회원 탈퇴하기", for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(clickDeleteAccountButton), for: .touchUpInside)
    }
    
    @objc private func clickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickCheckBoxButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor.gray300.cgColor
            sender.setImage(nil, for: .normal)
            sender.backgroundColor = .white
            deleteAccountButton.isEnabled = false
        } else {
            sender.isSelected = true
            sender.layer.borderWidth = 0
            if let selectedImage = UIImage(named: "check_image")?.withRenderingMode(.alwaysTemplate) {
                let resizedImage = selectedImage.resizeButtonImage(targetSize: CGSize(width: 16, height: 16))
                sender.setImage(resizedImage, for: .normal)
                sender.tintColor = .white
                sender.contentMode = .scaleAspectFit
            }
            sender.backgroundColor = .black
            deleteAccountButton.isEnabled = true
        }
    }
    
    @objc func clickDeleteAccountButton() {
        print("clickDeleteAccountButton 확인")
    }
}
