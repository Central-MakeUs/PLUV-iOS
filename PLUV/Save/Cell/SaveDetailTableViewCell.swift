//
//  SaveDetailTableViewCell.swift
//  PLUV
//
//  Created by jaegu park on 11/2/24.
//

import UIKit

class SaveDetailTableViewCell: UITableViewCell {

   static let identifier = String(describing: SaveDetailTableViewCell.self)
   
   private let thumbnailImageView = UIImageView().then {
      $0.layer.cornerRadius = 8
      $0.clipsToBounds = true
   }
   private let playButtonImageView = UIImageView().then {
      $0.image = UIImage(named: "playbutton_icon")
   }
   private let menuImageView = UIImageView().then {
      $0.image = UIImage(named: "menu_image")
   }
   private let playlistTitleLabel = UILabel().then {
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 18, weight: .medium)
   }
   private let totalCountLabel = UILabel().then {
      $0.textColor = .gray600
      $0.font = .systemFont(ofSize: 14, weight: .regular)
   }
   private let dateLabel = UILabel().then {
      $0.textColor = .gray600
      $0.font = .systemFont(ofSize: 14, weight: .regular)
   }
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
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
         make.leading.equalToSuperview().offset(24)
         make.centerY.equalToSuperview()
         make.width.equalTo(74)
         make.height.equalTo(74)
      }
      
      self.thumbnailImageView.addSubview(playButtonImageView)
      playButtonImageView.snp.makeConstraints { make in
         make.width.equalTo(12)
         make.height.equalTo(14)
         make.trailing.bottom.equalToSuperview().inset(6)
      }
      
      self.contentView.addSubview(menuImageView)
      menuImageView.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(24)
         make.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
         make.width.equalTo(20)
         make.height.equalTo(20)
      }
      
      self.contentView.addSubview(playlistTitleLabel)
      playlistTitleLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(22)
         make.leading.equalTo(menuImageView.snp.trailing).offset(4)
          make.trailing.equalToSuperview().inset(24)
         make.height.equalTo(24)
      }
      
      self.contentView.addSubview(totalCountLabel)
      totalCountLabel.snp.makeConstraints { make in
         make.top.equalTo(menuImageView.snp.bottom).offset(14)
         make.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
         make.height.equalTo(14)
      }
      
      self.contentView.addSubview(dateLabel)
      dateLabel.snp.makeConstraints { make in
         make.top.equalTo(menuImageView.snp.bottom).offset(14)
         make.leading.equalTo(totalCountLabel.snp.trailing).offset(6)
         make.height.equalTo(14)
      }
   }
   
   func prepare(feed: Feed) {
      let thumbNailUrl = URL(string: feed.thumbNailURL)
      self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
      self.playlistTitleLabel.text = feed.title
      self.totalCountLabel.text = "총 \(feed.totalSongCount ?? 0)곡"
      self.dateLabel.text = feed.transferredAt
   }
}
