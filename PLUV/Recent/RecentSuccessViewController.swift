//
//  ClassifySuccessViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class RecentSuccessViewController: UIViewController {
   
   let recentId = UserDefaults.standard.integer(forKey: "recentId")
   
   let successViewModel = SuccessViewModel()
   
   private let recentSuccessTableViewCell = UITableView().then {
      $0.separatorStyle = .none
      $0.register(RecentSuccessTableViewCell.self, forCellReuseIdentifier: RecentSuccessTableViewCell.identifier)
   }
   private let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
      setSuccessAPI()
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      self.view.addSubview(recentSuccessTableViewCell)
      recentSuccessTableViewCell.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(20)
         make.leading.trailing.bottom.equalToSuperview()
      }
   }
   
   private func setData() {
      self.recentSuccessTableViewCell.rx.setDelegate(self)
         .disposed(by: disposeBag)
      
      /// CollectionView에 들어갈 Cell에 정보 제공
      self.successViewModel.successItems
         .observe(on: MainScheduler.instance)
         .bind(to: self.recentSuccessTableViewCell.rx.items(cellIdentifier: RecentSuccessTableViewCell.identifier, cellType: RecentSuccessTableViewCell.self)) { index, item, cell in
            cell.prepare(music: item, index: index)
         }
         .disposed(by: disposeBag)
      
      /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
      self.recentSuccessTableViewCell.rx.modelSelected(Music.self)
         .subscribe(onNext: { [weak self] successItem in
            self?.successViewModel.selectSuccessItem = Observable.just(successItem)
         })
         .disposed(by: disposeBag)
   }
   
   private func setSuccessAPI() {
      let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
      let url = EndPoint.historySuccess("\(recentId)").path
      
      APIService().getWithAccessToken(of: APIResponse<[Music]>.self, url: url, AccessToken: loginToken) { response in
         switch response.code {
         case 200:
            self.successViewModel.successItems = Observable.just(response.data)
            self.setData()
            self.view.layoutIfNeeded()
         default:
            AlertController(message: response.msg).show()
         }
      }
   }
}

extension RecentSuccessViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
