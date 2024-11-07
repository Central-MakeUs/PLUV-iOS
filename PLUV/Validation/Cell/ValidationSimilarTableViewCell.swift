//
//  ValidationSimilarTableViewCell.swift
//  PLUV
//
//  Created by jaegu park on 11/1/24.
//

import UIKit

class ValidationSimilarTableViewCell: UITableViewCell {
   
   static let identifier = String(describing: ValidationSimilarTableViewCell.self)
   
   private let thumbnailImageView = UIImageView().then {
      $0.layer.cornerRadius = 8
      $0.clipsToBounds = true
   }
   private let originalSongView = UIView().then {
      $0.clipsToBounds = true
      
      let path = UIBezierPath(
         roundedRect: $0.bounds,
         byRoundingCorners: [.topLeft, .bottomRight],
         cornerRadii: CGSize(width: 8, height: 8) // 둥글기 설정
      )
      
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      $0.layer.mask = mask
   }
   private let originalSongLabel = UILabel().then {
      $0.text = "원곡"
      $0.font = .systemFont(ofSize: 10, weight: .medium)
      $0.textColor = .white
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
         make.top.equalToSuperview().offset(8)
         make.width.height.equalTo(50)
      }
      
      self.contentView.addSubview(originalSongView)
      originalSongView.snp.makeConstraints { make in
         make.leading.equalToSuperview().offset(24)
         make.top.equalToSuperview().offset(8)
         make.width.equalTo(30)
         make.height.equalTo(22)
      }
      
      self.originalSongView.addSubview(originalSongLabel)
      originalSongLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.centerX.equalToSuperview()
         make.height.equalTo(10)
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
}
