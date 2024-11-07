//
//  SaveViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SaveViewController: UIViewController {
   
   let viewModel = SaveViewModel()
   
   private let navigationbarView = NavigationBarView(title: "저장한 플레이리스트")
   private let saveDetailTableViewCell = UITableView().then {
      $0.separatorStyle = .none
      $0.register(SaveDetailTableViewCell.self, forCellReuseIdentifier: SaveDetailTableViewCell.identifier)
   }
   private let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
   
      setUI()
      setSaveAPI()
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
      
      self.view.addSubview(saveDetailTableViewCell)
      saveDetailTableViewCell.snp.makeConstraints { make in
         make.top.equalTo(navigationbarView.snp.bottom)
         make.leading.trailing.bottom.equalToSuperview()
      }
   }
   
   private func setData() {
      self.saveDetailTableViewCell.rx.setDelegate(self)
         .disposed(by: disposeBag)
      
      /// CollectionView에 들어갈 Cell에 정보 제공
      self.viewModel.saveItems
         .observe(on: MainScheduler.instance)
         .bind(to: self.saveDetailTableViewCell.rx.items(cellIdentifier: SaveDetailTableViewCell.identifier, cellType: SaveDetailTableViewCell.self)) { index, item, cell in
            cell.prepare(feed: item)
         }
         .disposed(by: disposeBag)
      
      /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
      self.saveDetailTableViewCell.rx.modelSelected(Feed.self)
         .subscribe(onNext: { [weak self] feedItem in
            self?.viewModel.selectSaveItem = Observable.just(feedItem)
            let saveDetailVC = SaveDetailViewController()
            saveDetailVC.saveId = feedItem.id
            self?.navigationController?.pushViewController(saveDetailVC, animated: true)
         })
         .disposed(by: disposeBag)
   }
   
   private func setSaveAPI() {
      let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
      let url = EndPoint.feedSave.path
      
      APIService().getWithAccessToken(of: APIResponse<[Feed]>.self, url: url, AccessToken: loginToken) { response in
         switch response.code {
         case 200:
            self.viewModel.saveItems = Observable.just(response.data)
            self.setData()
            self.view.layoutIfNeeded()
         default:
            AlertController(message: response.msg).show()
         }
      }
   }
}

extension SaveViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 94
   }
}
