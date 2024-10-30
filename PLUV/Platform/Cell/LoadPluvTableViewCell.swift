//
//  LoadPluvTableViewCell.swift
//  PLUV
//
//  Created by jaegu park on 10/29/24.
//

import UIKit

class LoadPluvTableViewCell: UITableViewCell {
   
   static let identifier = String(describing: LoadPluvTableViewCell.self)
   private let loadPluvContentView = UIView()
   let loadPluvImageView = UIImageView()
   private let loadPluvTitleLabel = UILabel().then {
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
      self.contentView.addSubview(loadPluvContentView)
      loadPluvContentView.snp.makeConstraints { make in
         make.leading.trailing.equalToSuperview().inset(24)
         make.top.bottom.equalToSuperview().inset(16)
      }
      
      self.loadPluvContentView.addSubview(loadPluvImageView)
      loadPluvImageView.snp.makeConstraints { make in
         make.leading.top.bottom.equalToSuperview()
         make.width.equalTo(loadPluvImageView.snp.height)
      }
      
      self.loadPluvContentView.addSubview(loadPluvTitleLabel)
      loadPluvTitleLabel.snp.makeConstraints { make in
         make.leading.equalTo(loadPluvImageView.snp.trailing).offset(16)
         make.centerY.equalTo(loadPluvImageView.snp.centerY)
      }
   }
   
   func prepare(from: LoadPluv) {
       self.loadPluvImageView.image = UIImage(named: from.icon)
       self.loadPluvTitleLabel.text = from.name
   }
}
