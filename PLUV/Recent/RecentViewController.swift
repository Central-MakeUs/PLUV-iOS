//
//  RecentDetailViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecentViewController: UIViewController {
   
   let viewModel = MeViewModel()
   
   private let navigationbarView = NavigationBarView(title: "최근 옮긴 항목")
   private let recentTableViewCell = UITableView().then {
      $0.separatorStyle = .none
      $0.register(RecentDetailTableViewCell.self, forCellReuseIdentifier: RecentDetailTableViewCell.identifier)
   }
   private let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
      setMeAPI()
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      self.view.addSubview(navigationbarView)
      navigationbarView.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(47)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(46)
      }
      navigationbarView.setBackButtonTarget(target: self)
      
      self.view.addSubview(recentTableViewCell)
      recentTableViewCell.snp.makeConstraints { make in
         make.top.equalTo(navigationbarView.snp.bottom)
         make.leading.trailing.bottom.equalToSuperview()
      }
   }
   
   private func setData() {
      self.recentTableViewCell.rx.setDelegate(self)
         .disposed(by: disposeBag)
      
      /// CollectionView에 들어갈 Cell에 정보 제공
      self.viewModel.meItems
         .observe(on: MainScheduler.instance)
         .bind(to: self.recentTableViewCell.rx.items(cellIdentifier: RecentDetailTableViewCell.identifier, cellType: RecentDetailTableViewCell.self)) { index, item, cell in
            cell.prepare(me: item)
         }
         .disposed(by: disposeBag)
      
      /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
      self.recentTableViewCell.rx.modelSelected(Me.self)
         .subscribe(onNext: { [weak self] recentItem in
            self?.viewModel.selectMeItem = Observable.just(recentItem)
            UserDefaults.standard.set(recentItem.id, forKey: "recentId")
            let recentDetailVC = RecentDetailViewController()
            self?.navigationController?.pushViewController(recentDetailVC, animated: true)
         })
         .disposed(by: disposeBag)
   }
   
   private func setMeAPI() {
      let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
      let url = EndPoint.historyMe.path
      
      APIService().getWithAccessToken(of: APIResponse<[Me]>.self, url: url, AccessToken: loginToken) { response in
         switch response.code {
         case 200:
            self.viewModel.meItems = Observable.just(response.data)
            self.setData()
            self.view.layoutIfNeeded()
         default:
            AlertController(message: response.msg).show()
         }
      }
   }
}

extension RecentViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 94
   }
}
