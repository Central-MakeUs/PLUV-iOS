//
//  ValidationNotFoundTableViewCell.swift
//  PLUV
//
//  Created by jaegu park on 11/1/24.
//

import UIKit

class ValidationNotFoundTableViewCell: UITableViewCell {
   
   static let identifier = String(describing: ValidationNotFoundTableViewCell.self)
   
   private let thumbnailImageView = UIImageView().then {
      $0.layer.cornerRadius = 8
      $0.clipsToBounds = true
   }
   private let songTitleLabel = UILabel().then {
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 16, weight: .medium)
   }
   private let singerLabel = UILabel().then {
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
         make.width.height.equalTo(50)
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
   }
    
    func prepare(music: SearchMusic) {
        let thumbNailUrl = URL(string: music.imageURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.songTitleLabel.text = music.title
        self.singerLabel.text = music.artistName
    }
}
