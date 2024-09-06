//
//  FeedDetailViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/31/24.
//

import UIKit

class FeedDetailViewController: UIViewController {
    
    init(viewModel: FeedViewModel) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigationBar()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setNavigationBar() {
        /// NavigationBar의 back 버튼 이미지 변경
        let backImage = UIImage(named: "backbutton_icon")?.withRenderingMode(.alwaysOriginal)
        let resizedBackImage = backImage?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 24, height: 24))
        let backButton = UIBarButtonItem(image: resizedBackImage, style: .plain, target: self, action: #selector(clickBackButton))
        backButton.tintColor = .gray800
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func clickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
