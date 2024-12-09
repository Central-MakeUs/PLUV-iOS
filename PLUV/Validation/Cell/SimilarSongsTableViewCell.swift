//
//  SimilarSongsTableViewCell.swift
//  PLUV
//
//  Created by jaegu park on 11/6/24.
//

import UIKit

class SimilarSongsTableViewCell: UITableViewCell {
   
   static let identifier = String(describing: SimilarSongsTableViewCell.self)

   private let barView = UIView().then {
      $0.backgroundColor = .gray200
   }
   private let thumbnailImageView = UIImageView().then {
      $0.image = UIImage(named: "applemusic_icon")
      $0.layer.cornerRadius = 8
      $0.clipsToBounds = true
   }
   private let songTitleLabel = UILabel().then {
      $0.text = "원곡"
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 16, weight: .medium)
   }
   private let singerLabel = UILabel().then {
      $0.text = "원곡"
      $0.textColor = .gray600
      $0.font = .systemFont(ofSize: 14, weight: .regular)
   }
   private let checkIcon = UIImageView().then {
      $0.image = UIImage(named: "check_image")
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
      self.contentView.addSubview(barView)
      barView.snp.makeConstraints { make in
         make.leading.equalToSuperview().offset(24)
         make.centerY.equalToSuperview()
         make.width.equalTo(4)
         make.height.equalTo(36)
      }
      
      self.contentView.addSubview(thumbnailImageView)
      thumbnailImageView.snp.makeConstraints { make in
         make.leading.equalTo(barView.snp.trailing).offset(8)
         make.centerY.equalToSuperview()
         make.width.height.equalTo(38)
      }
      
      self.contentView.addSubview(songTitleLabel)
      songTitleLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(15)
         make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
         make.height.equalTo(16)
      }
      
      self.contentView.addSubview(singerLabel)
      singerLabel.snp.makeConstraints { make in
         make.top.equalTo(songTitleLabel.snp.bottom).offset(6)
         make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
         make.height.equalTo(14)
      }
      
      self.contentView.addSubview(checkIcon)
      checkIcon.snp.makeConstraints { make in
         make.trailing.equalToSuperview().inset(24)
         make.centerY.equalToSuperview()
         make.height.width.equalTo(16)
      }
   }
    
    func prepare(music: SearchMusic) {
        let thumbNailUrl = URL(string: music.imageURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.songTitleLabel.text = music.title
        self.singerLabel.text = music.artistName
    }
    
    func updateSelectionUI(isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = .selectPurple
            self.checkIcon.image = UIImage(named: "check_image")
            self.barView.backgroundColor = .mainPurple
        } else {
            self.contentView.backgroundColor = .white
            self.checkIcon.image = nil
            self.barView.backgroundColor = .gray200
        }
    }
}
