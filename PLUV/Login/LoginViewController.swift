//
//  LoginViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/16/24.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "login_logo")
        $0.contentMode = .scaleAspectFit
    }
    private let loginTitleLabel = UILabel().then {
        $0.text = "로그인 후 모든 서비스를 이용해보세요!"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray800
        $0.textAlignment = .center
    }
    private let googleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "login_google_image"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    private let spotifyLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "login_spotify_image"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    private let appleLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "login_apple_image"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    private let loginSubLabel = UIImageView().then {
        $0.image = UIImage(named: "login_sub_label")
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setData()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        
        self.view.addSubview(loginTitleLabel)
        loginTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(26)
        }
        
        self.view.addSubview(googleLoginButton)
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(loginTitleLabel.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        self.view.addSubview(spotifyLoginButton)
        spotifyLoginButton.snp.makeConstraints { make in
            make.top.equalTo(googleLoginButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        self.view.addSubview(appleLoginButton)
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(spotifyLoginButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        self.view.addSubview(loginSubLabel)
        loginSubLabel.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.width.equalTo(196)
            make.height.equalTo(38)
        }
    }
    
    private func setData() {
        googleLoginButton.addTarget(self, action: #selector(clickGoogleLogin), for: .touchUpInside)
        spotifyLoginButton.addTarget(self, action: #selector(clickSpotifyLogin), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(clickAppleLogin), for: .touchUpInside)
    }
    
    @objc private func clickGoogleLogin() {
        let homeVC = HomeViewController()
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @objc private func clickSpotifyLogin() {
        
    }
    
    @objc private func clickAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func loginAPI(token: String) {
        let url = EndPoint.loginApple.path
        let params = ["idToken" : token]
        APIService().post(of: APIResponse<AccessTokenModel>.self, url: url, parameters: params) { response in
            switch response.code {
            case 200:
                print(response.data, "Bearer Access Token")
                let homeVC = HomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)\n")
                
                self.loginAPI(token: identifyTokenString)
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            //Move to MainPage
            //let validVC = SignValidViewController()
            //validVC.modalPresentationStyle = .fullScreen
            //present(validVC, animated: true, completion: nil)
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
