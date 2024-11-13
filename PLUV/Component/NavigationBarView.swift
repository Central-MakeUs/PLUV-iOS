//
//  NavigationBarView.swift
//  PLUV
//
//  Created by jaegu park on 11/5/24.
//

import UIKit

protocol NavigationBarViewDelegate: AnyObject {
    func didTapBackButton()
}

final class NavigationBarView: UIView {
   
   var backButton = UIButton().then {
      $0.setImage(UIImage(named: "backbutton_icon"), for: .normal)
   }
   var titleLabel = UILabel().then {
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 18, weight: .medium)
   }
   
   weak var delegate: NavigationBarViewDelegate?
   
   init(title: String) {
      super.init(frame: .zero)
      titleLabel.text = title
      setUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func setUI() {
      self.backgroundColor = .white
      
      self.addSubview(backButton)
      self.backButton.snp.makeConstraints { make in
         make.leading.equalToSuperview().inset(18)
         make.bottom.equalToSuperview().inset(11)
         make.width.height.equalTo(24)
      }
      
      self.addSubview(titleLabel)
      self.titleLabel.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.bottom.equalToSuperview().inset(11)
         make.height.equalTo(18)
      }
      
      backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
   }
   
   @objc private func backButtonTapped() {
         delegate?.didTapBackButton()
      }
}

extension UIViewController: NavigationBarViewDelegate {
    func didTapBackButton() {
       print("아")
        navigationController?.popViewController(animated: true)
    }
}
