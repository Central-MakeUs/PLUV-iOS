//
//  ClassifyFailViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class RecentFailViewController: UIViewController {
   
   let recentId = UserDefaults.standard.integer(forKey: "recentId")
   
   private let recentFailTableViewCell = UITableView().then {
      $0.separatorStyle = .none
      $0.register(RecentFailTableViewCell.self, forCellReuseIdentifier: RecentFailTableViewCell.identifier)
   }
   private let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      self.view.addSubview(recentFailTableViewCell)
      recentFailTableViewCell.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(20)
         make.leading.trailing.bottom.equalToSuperview()
      }
   }
}

extension RecentFailViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
