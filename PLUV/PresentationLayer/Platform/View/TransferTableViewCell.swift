//
//  TransferTableViewCell.swift
//  PLUV
//
//  Created by 백유정 on 7/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TransferTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: TransferTableViewCell.self)
    private var selectPlatform: String = MusicPlatform.AppleMusic.name
    
    private let platformContentView = UIView()
    private let platformImageView = UIImageView()
    private let platformTitleLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.contentView.addSubview(platformContentView)
        platformContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        self.platformContentView.addSubview(platformImageView)
        platformImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(platformImageView.snp.height)
        }
        
        self.platformContentView.addSubview(platformTitleLabel)
        platformTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.platformImageView.snp.trailing).offset(16)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
    
    func prepare(platform: MusicPlatform) {
        self.selectPlatform = platform.name
        self.platformImageView.image = UIImage(named: platform.icon)
        self.platformTitleLabel.text = platform.name
    }
}
