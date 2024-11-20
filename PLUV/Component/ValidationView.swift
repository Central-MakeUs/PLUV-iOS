//
//  ValidationView.swift
//  PLUV
//
//  Created by jaegu park on 11/11/24.
//

import UIKit

final class ValidationView: UIView {
   
   var mainView = UIView().then {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 12
   }
   var noSongImageView = UIImageView().then {
      $0.contentMode = .scaleAspectFill
   }
   var titleLabel = UILabel().then {
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 20, weight: .medium)
   }
   
   init(title: String, image: String) {
      super.init(frame: .zero)
      titleLabel.text = title
      noSongImageView.image = UIImage(named: image)
      setUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func setUI() {
      self.backgroundColor = UIColor(white: 0, alpha: 0.5)
      
      self.addSubview(mainView)
      self.mainView.snp.makeConstraints { make in
         make.center.equalToSuperview()
         make.leading.trailing.equalToSuperview().inset(49)
         make.height.equalTo(350)
      }
      
      self.mainView.addSubview(noSongImageView)
      self.noSongImageView.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(85)
         make.centerX.equalToSuperview()
         make.width.height.equalTo(78)
      }
      
      self.mainView.addSubview(titleLabel)
      self.titleLabel.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(noSongImageView.snp.bottom).offset(43)
         make.height.equalTo(52)
         make.width.equalTo(171)
      }
      
   }
}
