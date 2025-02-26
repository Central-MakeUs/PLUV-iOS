//
//  FeedCollectionViewCell.swift
//  PLUV
//
//  Created by 백유정 on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class FeedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FeedCollectionViewCell.self)
    
    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let playButtonImageView = UIImageView().then {
        $0.image = UIImage(named: "playbutton_icon")
    }
    private let playlistTitleLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let nickNameLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 14)
    }
    private let singerLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(thumbnailImageView.snp.width)
        }
        
        self.thumbnailImageView.addSubview(playButtonImageView)
        playButtonImageView.snp.makeConstraints { make in
            make.width.equalTo(18)
            make.height.equalTo(20)
            make.trailing.bottom.equalToSuperview().inset(15)
        }
        
        self.contentView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        self.contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(playlistTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(singerLabel)
        singerLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(38)
            make.bottom.equalToSuperview()
        }
    }
    
    func prepare(feed: Feed) {
        let thumbNailUrl = URL(string: feed.thumbNailURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.playlistTitleLabel.text = feed.title
        self.nickNameLabel.text = feed.creatorName
        self.singerLabel.text = feed.artistNames
    }
}
