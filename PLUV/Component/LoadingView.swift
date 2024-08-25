//
//  LoadingView.swift
//  PLUV
//
//  Created by 백유정 on 8/1/24.
//

import UIKit

final class LoadingView: UIView {
    
    var mainView = UIView().then { view in
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
    }
    var loadingImageView = UIImageView()
    var loadingTitleLabel = UILabel().then { label in
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .gray800
    }
    let loadingContainerView = UIView()
    let loadingBar = UIView()
    
    init(loadingState: LoadingState) {
        super.init(frame: .zero)
        setUI(loadingState.image, loadingState.label)
        startLoadingAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(_ imageName: String, _ titleLabel: String) {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        self.addSubview(mainView)
        self.mainView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(292)
            make.height.equalTo(350)
        }
        
        self.mainView.addSubview(loadingImageView)
        self.loadingImageView.image = UIImage(named: imageName)
        self.loadingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(70)
        }
        
        self.mainView.addSubview(loadingTitleLabel)
        self.loadingTitleLabel.text = titleLabel
        self.loadingTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingImageView.snp.bottom).offset(40)
            make.width.equalToSuperview()
            make.height.equalTo(52)
        }
        
        // 로딩 바 컨테이너 설정 (고정된 너비 200)
        self.mainView.addSubview(loadingContainerView)
        self.loadingContainerView.backgroundColor = .gray200
        self.loadingContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingTitleLabel.snp.bottom).offset(25)
            make.width.equalTo(200)
            make.height.equalTo(4)
        }
        
        // 움직이는 로딩 바 설정 (컨테이너보다 좁게)
        self.loadingContainerView.addSubview(loadingBar)
        self.loadingBar.backgroundColor = .mainPurple
        self.loadingBar.layer.cornerRadius = 2
        self.loadingBar.snp.makeConstraints { make in
            make.leading.equalToSuperview() // 처음 위치를 왼쪽에 맞춘다
            make.centerY.equalToSuperview()
            make.width.equalTo(80) // 너비를 더 좁게 설정
            make.height.equalToSuperview()
        }
    }
    
    func startLoadingAnimation() {
        let loadingBarWidth = 80 // 로딩 바의 너비
        let containerWidth = 200 // 고정된 컨테이너의 너비
        
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                self.loadingBar.transform = CGAffineTransform(translationX: CGFloat(containerWidth - loadingBarWidth), y: 0)
            }
        }, completion: nil)
    }
}
