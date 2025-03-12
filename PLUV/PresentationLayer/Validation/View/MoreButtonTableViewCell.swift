//
//  MoreButtonTableViewCell.swift
//  PLUV
//
//  Created by jaegu park on 11/6/24.
//

import UIKit

class MoreButtonTableViewCell: UITableViewCell {
   
   static let identifier = String(describing: MoreButtonTableViewCell.self)

   private let barView = UIView().then {
      $0.backgroundColor = .clear
      $0.layer.borderColor = UIColor.gray200.cgColor
      $0.layer.borderWidth = 1.0
      $0.layer.cornerRadius = 8
   }
   private let moreLabel = UILabel().then {
      $0.text = "항목 더보기"
      $0.textColor = .gray600
      $0.font = .systemFont(ofSize: 14, weight: .medium)
   }
   private let moreButton = UIButton().then {
      $0.setImage(UIImage(named: "morebutton_icon"), for: .normal)
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
         make.top.equalToSuperview().offset(8)
         make.leading.trailing.equalToSuperview().inset(24)
         make.centerX.equalToSuperview()
         make.height.equalTo(38)
      }
      
      self.barView.addSubview(moreLabel)
      moreLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.leading.equalToSuperview().offset(12)
         make.height.equalTo(14)
      }
      
      self.barView.addSubview(moreButton)
      moreButton.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.trailing.equalToSuperview()
         make.width.height.equalTo(35)
      }
   }
}
