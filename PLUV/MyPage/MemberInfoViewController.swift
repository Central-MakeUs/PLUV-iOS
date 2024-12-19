//
//  MemberInfoViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit

class MemberInfoViewController: UIViewController, UITextFieldDelegate {
    
    private let navigationbarView = NavigationBarView(title: "회원 정보")
    private let nickNameView = UIView()
    private let nickNameTitleLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    private let nickNameLabel = UILabel().then {
        $0.text = "플러버"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private var editButton = WhiteButton()
    private let nickNameTextField = UITextField().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.placeholder = "새 닉네임"
        $0.setPlaceholderColor(.black)
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .black
    }
    private let textCountLabel = UILabel().then {
        $0.text = "0/10"
        $0.textColor = .gray500
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .left
    }
    private let separatorView1 = UIView().then {
        $0.backgroundColor = .gray200
    }
    private let socialConnectView = UIView()
    private let socialConnectLabel = UILabel().then {
        $0.text = "연결된 소셜 계정"
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    private let socialLabel = UILabel().then {
        $0.text = "스포티파이"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let separatorView2 = UIView().then {
        $0.backgroundColor = .gray200
    }
    private let socialAddView = UIView()
    private let socialAddLabel = UILabel().then {
        $0.text = "소셜 계정 추가 연결하기"
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    private let socialAppleButton = UIButton().then {
        $0.setImage(UIImage(named: "connect_apple_image"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("  Apple 연결하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setBackgroundColor(.gray800, for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
    }
    private let socialSpotifyButton = UIButton().then {
        $0.setImage(UIImage(named: "connect_spotify_image"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("  스포티파이 연결하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setBackgroundColor(UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
    }
    private let separatorView3 = UIView().then {
        $0.backgroundColor = .gray200
    }
    private let deleteAccountView = UIView()
    private let deleteAccountLabel = UILabel().then {
        $0.text = "회원 탈퇴"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private var isToggled = false
    
    private let maxCharacterLimit = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationbarView.delegate = self
        self.view.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(93)
        }
        
        self.view.addSubview(nickNameView)
        nickNameView.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
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
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        self.nickNameView.addSubview(editButton)
        self.editButton.setTitle("수정", for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        editButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTitleLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.width.equalTo(65)
        }
        editButton.addTarget(self, action: #selector(nickNameEdit), for: .touchUpInside)
        
        self.nickNameView.addSubview(nickNameTextField)
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(editButton.snp.leading).inset(-12)
            make.height.equalTo(44)
        }
        nickNameTextField.isHidden = true
        nickNameTextField.setLeftPadding(12)
        nickNameTextField.errorfix()
        nickNameTextField.delegate = self
        
        self.nickNameView.addSubview(textCountLabel)
        textCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameTextField)
            make.trailing.equalTo(editButton.snp.leading).inset(-20)
            make.height.equalTo(26)
            make.width.equalTo(36)
        }
        textCountLabel.isHidden = true
        
        self.view.addSubview(separatorView1)
        separatorView1.snp.makeConstraints { make in
            make.top.equalTo(nickNameView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1.2)
        }
        
        self.view.addSubview(socialConnectView)
        socialConnectView.snp.makeConstraints { make in
            make.top.equalTo(separatorView1.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        self.socialConnectView.addSubview(socialConnectLabel)
        socialConnectLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        
        self.socialConnectView.addSubview(socialLabel)
        socialLabel.snp.makeConstraints { make in
            make.top.equalTo(socialConnectLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(separatorView2)
        separatorView2.snp.makeConstraints { make in
            make.top.equalTo(socialConnectView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1.2)
        }
        
        self.view.addSubview(socialAddView)
        socialAddView.snp.makeConstraints { make in
            make.top.equalTo(separatorView2.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.socialAddView.addSubview(socialAddLabel)
        socialAddLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        
        self.socialAddView.addSubview(socialAppleButton)
        socialAppleButton.snp.makeConstraints { make in
            make.top.equalTo(socialAddLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        self.socialAddView.addSubview(socialSpotifyButton)
        socialSpotifyButton.snp.makeConstraints { make in
            make.top.equalTo(socialAppleButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        self.view.addSubview(separatorView3)
        separatorView3.snp.makeConstraints { make in
            make.top.equalTo(socialAddView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1.2)
        }
        
        self.view.addSubview(deleteAccountView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickDeleteAccountView))
        deleteAccountView.addGestureRecognizer(tapGesture)
        deleteAccountView.snp.makeConstraints { make in
            make.top.equalTo(separatorView3.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        self.deleteAccountView.addSubview(deleteAccountLabel)
        deleteAccountLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(18)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }

        let updatedLength = currentText.count + string.count - range.length

        textCountLabel.text = "\(updatedLength)/\(maxCharacterLimit)"
        return updatedLength < maxCharacterLimit
    }
    
    @objc func nickNameEdit() {
        isToggled.toggle()
        
        if isToggled {
            nickNameTextField.isHidden = false
            textCountLabel.isHidden = false
            nickNameLabel.isHidden = true
            editButton.setTitle("완료", for: .normal)
            editButton.setTitleColor(.white, for: .normal)
            editButton.backgroundColor = .black
            editButton.layer.borderColor = UIColor.black.cgColor
        } else {
            nickNameTextField.isHidden = true
            textCountLabel.isHidden = true
            nickNameLabel.isHidden = false
            editButton.setTitle("수정", for: .normal)
            editButton.setTitleColor(.black, for: .normal)
            editButton.backgroundColor = .white
            editButton.layer.borderColor = UIColor.gray300.cgColor
        }
    }
    
    @objc func clickDeleteAccountView() {
        let deleteAccountVC = DeleteAccountViewController()
        self.navigationController?.pushViewController(deleteAccountVC, animated: true)
    }
}
