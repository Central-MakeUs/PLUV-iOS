//
//  NavigationBarView.swift
//  PLUV
//
//  Created by jaegu park on 11/5/24.
//

import UIKit

final class NavigationBarView: UIView {
   
   var backButton = UIButton().then {
      $0.setImage(UIImage(named: "backbutton_icon"), for: .normal)
   }
   var titleLabel = UILabel().then {
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 18, weight: .medium)
   }
   
   init(title: String) {
      super.init(frame: .zero)
      titleLabel.text = title
      setUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func setUI() {
      self.backgroundColor = .clear
      
      self.addSubview(backButton)
      self.backButton.snp.makeConstraints { make in
         make.leading.equalToSuperview().inset(18)
         make.centerY.equalToSuperview()
         make.width.height.equalTo(24)
      }
      
      self.addSubview(titleLabel)
      self.titleLabel.snp.makeConstraints { make in
         make.centerY.equalToSuperview()
         make.centerX.equalToSuperview()
         make.height.equalTo(18)
      }
   }
   
   func setBackButtonTarget(target: UIViewController) {
      backButton.addTarget(target, action: #selector(target.popViewController), for: .touchUpInside)
   }
}

extension UIViewController {
   @objc func popViewController() {
      navigationController?.popViewController(animated: true)
   }
}