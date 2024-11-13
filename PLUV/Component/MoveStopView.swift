//
//  MoveStopView.swift
//  PLUV
//
//  Created by jaegu park on 11/10/24.
//

import UIKit

final class MoveStopView: UIView {
   
   private var num: Int = 1
   private weak var targetViewController: UIViewController?
   
   var mainView = UIView().then {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 12
   }
   var backButton = UIButton().then {
      $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
   }
   var titleLabel = UILabel().then {
      $0.text = "옮기기를 중단할까요?"
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 20, weight: .medium)
   }
   var stopLabel = UILabel().then {
      $0.textColor = .red
      $0.textAlignment = .center
      $0.font = .systemFont(ofSize: 16, weight: .medium)
   }
   var okButton = UIButton().then {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 8
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.gray300.cgColor
      $0.setTitle("확인", for: .normal)
      $0.setTitleColor(.gray800, for: .normal)
   }
   
   init(title: String, target: UIViewController, num: Int) {
      super.init(frame: .zero)
      stopLabel.text = title
      self.targetViewController = target
      self.num = num
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
         make.height.equalTo(293)
      }
      
      self.mainView.addSubview(backButton)
      self.backButton.snp.makeConstraints { make in
         make.top.trailing.equalToSuperview().inset(14)
         make.width.height.equalTo(32)
      }
      
      self.mainView.addSubview(titleLabel)
      self.titleLabel.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(backButton.snp.bottom).offset(18)
         make.height.equalTo(26)
      }
      
      self.mainView.addSubview(stopLabel)
      self.stopLabel.snp.makeConstraints { make in
         make.top.equalTo(titleLabel.snp.bottom).offset(33)
         make.leading.trailing.equalToSuperview().inset(22)
         make.height.equalTo(48)
      }
      
      self.mainView.addSubview(okButton)
      self.okButton.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(stopLabel.snp.bottom).offset(43)
         make.leading.trailing.equalToSuperview().inset(20)
         make.height.equalTo(54)
      }
      
      self.okButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
      self.backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
   }
   
   @objc private func backButtonTapped() {
      if let target = targetViewController {
         setBackButtonTarget(target: target, num: num)
      }
   }
   
   @objc private func dismissView() {
      UIView.animate(withDuration: 0.3, animations: {
         self.alpha = 0
      }) { _ in
         self.removeFromSuperview() // 애니메이션 후 뷰에서 제거
      }
   }
   
   func setBackButtonTarget(target: UIViewController, num: Int) {
      if let navigationController = target.navigationController {
         let viewControllers = navigationController.viewControllers
         if viewControllers.count > 1 {
            let previousViewController = viewControllers[viewControllers.count - num]
            navigationController.popToViewController(previousViewController, animated: true)
         }
      }
   }
}
