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
   
   let failViewModel = FailViewModel()
   
   private let recentFailTableViewCell = UITableView().then {
      $0.separatorStyle = .none
      $0.register(RecentFailTableViewCell.self, forCellReuseIdentifier: RecentFailTableViewCell.identifier)
   }
   private let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
      setFailAPI()
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
   
   private func setData() {
      self.recentFailTableViewCell.rx.setDelegate(self)
         .disposed(by: disposeBag)
      
      /// CollectionView에 들어갈 Cell에 정보 제공
      self.failViewModel.failItems
         .observe(on: MainScheduler.instance)
         .bind(to: self.recentFailTableViewCell.rx.items(cellIdentifier: RecentFailTableViewCell.identifier, cellType: RecentFailTableViewCell.self)) { index, item, cell in
            cell.prepare(music: item, index: index)
         }
         .disposed(by: disposeBag)
      
      /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
      self.recentFailTableViewCell.rx.modelSelected(Music.self)
         .subscribe(onNext: { [weak self] failItem in
            self?.failViewModel.selectFailItem = Observable.just(failItem)
         })
         .disposed(by: disposeBag)
   }
   
   private func setFailAPI() {
      let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
      let url = EndPoint.historyFail("\(recentId)").path
      
      APIService().getWithAccessToken(of: APIResponse<[Music]>.self, url: url, AccessToken: loginToken) { response in
           switch response.code {
           case 200:
              self.failViewModel.failItems = Observable.just(response.data)
               self.setData()
               self.view.layoutIfNeeded()
           default:
               AlertController(message: response.msg).show()
           }
       }
   }
}

extension RecentFailViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
