//
//  PlatformView.swift
//  PLUV
//
//  Created by 백유정 on 8/6/24.
//

import UIKit

final class PlatformView: UIView {
    
    var platformImageView = UIImageView()
    var platformTitleLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14)
    }
    
    init(platform: MusicPlatform) {
        super.init(frame: .zero)
        setUI(platform)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(_ platform: MusicPlatform) {
        self.backgroundColor = .clear
        
        self.addSubview(platformImageView)
        self.platformImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(88)
        }
        
        self.addSubview(platformTitleLabel)
        self.platformTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(platformImageView.snp.bottom).offset(7)
            make.centerX.equalTo(platformImageView.snp.centerX)
            make.bottom.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.platformImageView.image = UIImage(named: platform.iconSelect)
        self.platformTitleLabel.text = platform.name
    }
}
