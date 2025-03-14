//
//  HomeViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/9/24.
//

import UIKit
import StoreKit
import SnapKit
import Then
import MusicKit

class HomeViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backgroundhome_image")
    }
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "homelogo_image")
        $0.contentMode = .scaleAspectFit
    }
    private let transferDirectButton = UIButton().then {
        $0.setImage(UIImage(named: "homebutton_direct_image"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    private let transferScreenshotButton = UIButton().then {
        $0.setImage(UIImage(named: "homebutton_screenshot_image"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    private let myPlaylistImageView = UIImageView().then {
        $0.image = UIImage(named: "myplaylist_image")
    }
    private let recentListImageView = UIImageView().then {
        $0.image = UIImage(named: "recentlist_image")
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
    }
    private let recentEmptyLabel = UILabel().then {
        $0.text = "최근 옮긴 항목이 없습니다."
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .gray400
        $0.textAlignment = .center
    }
    private let saveListImageView = UIImageView().then {
        $0.image = UIImage(named: "savelist_image")
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
    }
    private let saveEmptyLabel = UILabel().then {
        $0.text = "저장한 플레이리스트가 없습니다."
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .gray400
        $0.textAlignment = .center
    }
    
    var musicList: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 표시하기
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension HomeViewController {
    
    private func setUI() {
        self.view.backgroundColor = .gray100
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false

        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(940)
        }
        
        self.contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(359)
        }
        
        self.contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(62)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(66)
            make.height.equalTo(24)
        }
        
        self.contentView.addSubview(transferDirectButton)
        transferDirectButton.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(106)
        }
        transferDirectButton.addTarget(self, action: #selector(clickTransferDirectButton), for: .touchUpInside)
        
        self.contentView.addSubview(transferScreenshotButton)
        transferScreenshotButton.snp.makeConstraints { make in
            make.top.equalTo(transferDirectButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(106)
        }
        transferScreenshotButton.addTarget(self, action: #selector(clickTransferScreenshotButton), for: .touchUpInside)
        
        self.contentView.addSubview(myPlaylistImageView)
        myPlaylistImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        
        self.contentView.addSubview(recentListImageView)
        recentListImageView.snp.makeConstraints { make in
            make.top.equalTo(myPlaylistImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        self.contentView.addSubview(recentEmptyLabel)
        recentEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(recentListImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
        
        self.contentView.addSubview(saveListImageView)
        saveListImageView.snp.makeConstraints { make in
            make.top.equalTo(recentListImageView.snp.bottom).offset(176)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        self.contentView.addSubview(saveEmptyLabel)
        saveEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(saveListImageView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(16)
        }
    }
    
    @objc private func clickTransferDirectButton() {
        let transferSourceViewController = TransferSourceViewController()
        self.navigationController?.pushViewController(transferSourceViewController, animated: true)
    }
    
    @objc private func clickTransferScreenshotButton() {
        AlertController(message: "추후 공개될 예정이에요!").show()
    }
    
    /// 테스트
    private func setTestAppleMusic() {
        MusicKitManager.shared.fetchMusic("알레프")
    }
}
