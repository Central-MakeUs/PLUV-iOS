//
//  purpleProgressView.swift
//  PLUV
//
//  Created by jaegu park on 11/3/24.
//

import UIKit

class CustomProgressView: UIView {
   
   var progressView = UIProgressView().then {
      $0.progressTintColor = UIColor(red: 143/255, green: 0/255, blue: 255/255, alpha: 1.0)
      $0.trackTintColor = .gray200
      $0.progress = 0.0
      $0.clipsToBounds = true
   }
   
   init() {
      super.init(frame: .zero)
      setUI()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   func setUI() {
      self.backgroundColor = .clear
      
      self.addSubview(progressView)
      self.progressView.snp.makeConstraints { make in
         make.leading.top.trailing.equalToSuperview()
         make.height.equalTo(4)
      }
   }
   
   func updateProgress(to progress: Float) {
      progressView.setProgress(progress, animated: true)
   }
}
