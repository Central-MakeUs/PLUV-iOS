//
//  RecentCollectionViewCell.swift
//  PLUV
//
//  Created by jaegu park on 10/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class RecentCollectionViewCell: UICollectionViewCell {
   
   static let identifier = String(describing: RecentCollectionViewCell.self)
   
   private let thumbnailImageView = UIImageView().then {
      $0.layer.cornerRadius = 8
      $0.clipsToBounds = true
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
         make.top.leading.trailing.bottom.equalToSuperview()
      }
   }
   
   func prepare(feed: Feed) {
       let thumbNailUrl = URL(string: feed.thumbNailURL)
       self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
   }
}