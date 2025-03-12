//
//  TransferPlaylistCollectionViewCell.swift
//  PLUV
//
//  Created by 백유정 on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class SelectPlaylistCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SelectPlaylistCollectionViewCell.self)
    
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
    private let songCountLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = .systemFont(ofSize: 12)
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = .systemFont(ofSize: 12)
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
        
        /*
         self.thumbnailImageView.addSubview(playButtonImageView)
         playButtonImageView.snp.makeConstraints { make in
         make.width.equalTo(17)
         make.height.equalTo(19)
         make.trailing.bottom.equalToSuperview().inset(12)
         }
         */
        
        self.contentView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20) /// g, y, p 같은 문자 이슈로 2point 늘림
        }
        
        self.contentView.addSubview(songCountLabel)
        songCountLabel.snp.makeConstraints { make in
            make.top.equalTo(playlistTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.height.equalTo(12)
        }
        
        self.contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(songCountLabel.snp.top)
            make.leading.equalTo(songCountLabel.snp.trailing).offset(6)
            make.height.equalTo(songCountLabel.snp.height)
        }
    }
    
    func prepare(playlist: Playlist, platform: PlatformRepresentable) {
        self.dateLabel.isHidden = true
        if let musicPlatform = platform as? MusicPlatform, musicPlatform == .AppleMusic {
            self.songCountLabel.isHidden = true
        }
        
        let thumbNailUrl = URL(string: playlist.thumbnailURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.playlistTitleLabel.text = playlist.name
        self.songCountLabel.text = "총 \(String(playlist.songCount ?? 0))곡"
        self.dateLabel.text = "2024.04.20"
        
        let borderWidth: CGFloat = 2.4
        thumbnailImageView.frame = CGRectInset(self.frame, -borderWidth, -borderWidth)
        thumbnailImageView.layer.borderColor = UIColor.mainPurple.cgColor
        thumbnailImageView.layer.borderWidth = 0
    }
    
    func mePrepare(me: Me, platform: PlatformRepresentable) {
        let thumbNailUrl = URL(string: me.imageURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.playlistTitleLabel.text = me.title
        self.songCountLabel.text = "총 \(me.transferredSongCount)곡"
        self.dateLabel.text = "\(me.transferredDate)"
        
        let borderWidth: CGFloat = 2.4
        thumbnailImageView.frame = CGRectInset(self.frame, -borderWidth, -borderWidth)
        thumbnailImageView.layer.borderColor = UIColor.mainPurple.cgColor
        thumbnailImageView.layer.borderWidth = 0
    }
    
    func savePrepare(feed: Feed, platform: PlatformRepresentable) {
        let thumbNailUrl = URL(string: feed.thumbNailURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.playlistTitleLabel.text = feed.title
        self.songCountLabel.text = "총 \(feed.totalSongCount ?? 0)곡"
        self.dateLabel.text = "\(feed.transferredAt)"
        
        let borderWidth: CGFloat = 2.4
        thumbnailImageView.frame = CGRectInset(self.frame, -borderWidth, -borderWidth)
        thumbnailImageView.layer.borderColor = UIColor.mainPurple.cgColor
        thumbnailImageView.layer.borderWidth = 0
    }
    
    func updateSelectionUI(isSelected: Bool) {
        thumbnailImageView.layer.borderWidth = isSelected ? 2.4 : 0
    }
}
