//
//  MovePlaylistViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/18/24.
//

import UIKit

class MovePlaylistViewController: UIViewController {
    
    private let circleLoadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.mainPurple], lineWidth: 6)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    private var circleBackgroundView = UIView().then {
        $0.backgroundColor = .loadingBackgroundPurple
        $0.layer.cornerRadius = 150
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 150
        $0.layer.masksToBounds = false
    }
    private let innerCircleView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 144
        $0.clipsToBounds = true
    }
    
    private let centerContentView = UIView()
    private var sourceImageView = UIImageView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 8
    }
    private let dotImageView = UIImageView().then {
        $0.image = UIImage(named: "movedot_image")
    }
    private var destinationImageView = UIImageView().then {
        $0.image = UIImage(named: MusicPlatform.AppleMusic.iconSelect)
    }
    
    private let playlistTitleView = UIView()
    private let menuImageView = UIImageView().then {
        $0.image = UIImage(named: "menu_image")
    }
    private var playlistTitleLabel = UILabel().then {
        $0.text = "여유로운 오후의 취향 저격 팝"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18)
    }
    private var platformLabel = UILabel().then {
        $0.text = "스포티파이 > 애플뮤직"
        $0.textColor = .subBlue
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    private let stopView = ActionBottomView(actionName: "작업 중단하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        circleLoadingIndicator.isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.circleLoadingIndicator.isAnimating = false
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "플레이리스트 옮기기"
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.view.addSubview(circleBackgroundView)
        circleBackgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        self.view.addSubview(innerCircleView)
        innerCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(288)
        }
        
        self.view.addSubview(circleLoadingIndicator)
        circleLoadingIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(295)
        }
        
        /// center content view
        self.centerContentView.addSubview(sourceImageView)
        sourceImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(52)
            make.centerX.equalToSuperview()
        }
        
        self.centerContentView.addSubview(dotImageView)
        dotImageView.snp.makeConstraints { make in
            make.top.equalTo(sourceImageView.snp.bottom).offset(12)
            make.width.equalTo(6)
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
        }
        
        self.centerContentView.addSubview(destinationImageView)
        destinationImageView.snp.makeConstraints { make in
            make.top.equalTo(dotImageView.snp.bottom).offset(12)
            make.width.height.equalTo(97)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(centerContentView)
        centerContentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(stopView)
        stopView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        self.view.addSubview(platformLabel)
        platformLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(stopView.snp.top).offset(-20)
            make.height.equalTo(14)
        }
        
        self.playlistTitleView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        
        self.playlistTitleView.addSubview(menuImageView)
        menuImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(playlistTitleLabel.snp.leading).offset(-4)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(playlistTitleView)
        playlistTitleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.bottom.equalTo(platformLabel.snp.top).offset(-8)
        }
    }
}
