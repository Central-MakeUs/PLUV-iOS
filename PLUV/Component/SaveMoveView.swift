//
//  SaveMoveView.swift
//  PLUV
//
//  Created by jaegu park on 10/27/24.
//

import UIKit
import Then

final class SaveMoveView: UIView {
   
   private let saveButton = UIButton().then {
      $0.setImage(UIImage(named: "savebutton_icon"), for: .normal)
   }
   private let saveLabel = UILabel().then {
      $0.text = "저장"
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 16, weight: .medium)
   }
   private let moveButton = UIButton().then {
      $0.setTitle("플레이리스트 옮기기", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
      $0.setTitleColor(.white, for: .normal)
      $0.backgroundColor = .black
      $0.layer.cornerRadius = 10
      $0.clipsToBounds = true
   }
   var view: UIViewController
   
   private var isOriginalColor = true
   
   init(view: UIViewController) {
      self.view = view
      super.init(frame: .zero)
      setUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func setUI() {
      self.backgroundColor = .white
      
      self.addSubview(saveButton)
      saveButton.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(18)
         make.leading.equalToSuperview().offset(30)
         make.width.equalTo(40)
         make.height.equalTo(40)
      }
      saveButton.addTarget(self, action: #selector(saveButtonColor), for: .touchUpInside)
      
      self.addSubview(saveLabel)
      saveLabel.snp.makeConstraints { make in
         make.centerY.equalTo(saveButton)
         make.leading.equalTo(saveButton.snp.trailing)
         make.width.equalTo(28)
         make.height.equalTo(16)
      }
      
      self.addSubview(moveButton)
      self.moveButton.setTitle("플레이리스트 옮기기", for: .normal)
      moveButton.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(10)
         make.leading.equalTo(saveLabel.snp.trailing).offset(35)
         make.trailing.equalToSuperview().inset(24)
         make.height.equalTo(58)
      }
      
      shadow()
   }
   
   func shadow() {
      self.layer.shadowOpacity = 0.2
      self.layer.shadowRadius = 2
      self.layer.shadowOffset = CGSize(width: 0, height: -2)
   }
   
   @objc func saveButtonColor() {
      if isOriginalColor {
         saveButton.setImage(UIImage(named: "savebutton_icon"), for: .normal)
      } else {
         saveButton.setImage(UIImage(named: "savebutton_icon2"), for: .normal)
      }
      isOriginalColor.toggle()
   }
}