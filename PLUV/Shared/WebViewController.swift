//
//  WebViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var urlString: String?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupCustomBackButton()
    }
    
    func setup(){
        webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupCustomBackButton() {
        /// NavigationBar의 back 버튼 이미지 변경
        let backImage = UIImage(named: "backbutton_icon")?.withRenderingMode(.alwaysOriginal)
        let resizedBackImage = backImage?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 24, height: 24))
        let backButton = UIBarButtonItem(image: resizedBackImage, style: .plain, target: self, action: #selector(clickBackButton))
        backButton.tintColor = .gray800
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func clickBackButton() {
        // 웹 페이지 뒤로 가기 또는 네비게이션 컨트롤러에서 pop
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
