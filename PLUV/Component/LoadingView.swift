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
    }
    var loadingBar = UIView()
    
    init(loadingState: LoadingState) {
        super.init(frame: .zero)
        setUI(loadingState.image, loadingState.label)
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
        
        self.mainView.addSubview(loadingBar)
        self.loadingBar.backgroundColor = .mainPurple
        self.loadingBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingTitleLabel.snp.bottom).offset(25)
            make.width.equalTo(200)
            make.height.equalTo(4)
        }
    }
}
