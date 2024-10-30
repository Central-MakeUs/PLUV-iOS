//
//  ClassifyFailViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/23/24.
//

import UIKit

class RecentFailViewController: UIViewController {
   
   private let recentListLabel = UILabel().then {
      $0.text = "최근 옮긴 항목"
      $0.font = .systemFont(ofSize: 18, weight: .semibold)
      $0.textColor = .gray800
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      
      self.view.addSubview(recentListLabel)
      recentListLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(60)
         make.leading.equalToSuperview().offset(24)
      }
   }
}
