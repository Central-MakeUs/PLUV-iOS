//
//  TransferSourceViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/13/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TransferSourceViewController: UIViewController {
   
   private let sourceList = Observable.just(MusicPlatform.allCases)
   private let fromList = Observable.just(LoadPluv.allCases)
   
   private let sourceTitleView = UIView()
   private let backButton = UIButton().then {
      $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
   }
   private let progressView = CustomProgressView()
   private let sourceTitleLabel = UILabel().then {
      $0.text = "어디에서\n플레이리스트를 불러올까요?"
      $0.numberOfLines = 0
      $0.font = .systemFont(ofSize: 24, weight: .semibold)
      $0.textColor = .gray800
   }
   private let sourceTableView = UITableView().then {
      $0.separatorStyle = .none
      $0.register(TransferTableViewCell.self, forCellReuseIdentifier: TransferTableViewCell.identifier)
      $0.tag = 1
   }
   private let loadFromLabel = UILabel().then {
      $0.text = "플럽에서 불러오기"
      $0.font = .systemFont(ofSize: 16, weight: .medium)
      $0.textColor = .gray800
   }
   private let backgroundLabel = UILabel().then {
      $0.backgroundColor = .gray200
   }
   private let loadPlubTableView = UITableView().then {
      $0.separatorStyle = .none
      $0.register(LoadPluvTableViewCell.self, forCellReuseIdentifier: LoadPluvTableViewCell.identifier)
      $0.tag = 2
   }
   
   private var moveView = MoveView()
   private let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
      setSourceData()
      setFromData()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      /// 탭 바 숨기기
      self.tabBarController?.tabBar.isHidden = true
   }
}

extension TransferSourceViewController {
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      self.view.addSubview(sourceTitleView)
      sourceTitleView.snp.makeConstraints { make in
         make.top.leading.trailing.equalToSuperview()
         make.height.equalTo(213)
      }
      
      self.sourceTitleView.addSubview(backButton)
      backButton.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(53)
         make.trailing.equalToSuperview().inset(20)
         make.height.equalTo(34)
         make.width.equalTo(34)
      }
      backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
      
      self.sourceTitleView.addSubview(progressView)
      progressView.snp.makeConstraints { make in
         make.top.equalTo(backButton.snp.bottom).offset(6)
         make.trailing.leading.equalToSuperview()
         make.height.equalTo(4)
      }
      progressView.updateProgress(to: 0.125)
      
      self.sourceTitleView.addSubview(sourceTitleLabel)
      sourceTitleLabel.snp.makeConstraints { make in
         make.top.equalTo(progressView.snp.bottom).offset(24)
         make.leading.equalToSuperview().inset(24)
         make.height.equalTo(68)
      }
      
      self.view.addSubview(sourceTableView)
      sourceTableView.snp.makeConstraints { make in
         make.top.equalTo(sourceTitleView.snp.bottom)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(276)
      }
      
      self.view.addSubview(loadFromLabel)
      loadFromLabel.snp.makeConstraints { make in
         make.top.equalTo(sourceTableView.snp.bottom).inset(30)
         make.leading.equalToSuperview().inset(24)
         make.height.equalTo(16)
      }
      
      self.view.addSubview(backgroundLabel)
      backgroundLabel.snp.makeConstraints { make in
         make.top.equalTo(loadFromLabel.snp.bottom).offset(10)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(1.2)
      }
      
      self.view.addSubview(loadPlubTableView)
      loadPlubTableView.snp.makeConstraints { make in
         make.top.equalTo(backgroundLabel.snp.bottom)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(184)
      }
      
      self.view.addSubview(moveView)
      moveView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.height.equalTo(101)
      }
      moveView.setBackButtonTarget(target: self)
      
      moveView.backButton.isEnabled = false
      moveView.trasferButton.isEnabled = false
      
      // sourceTableView.isScrollEnabled = false
   }
   
   private func setSourceData() {
      self.sourceTableView.rx.setDelegate(self)
         .disposed(by: self.disposeBag)
      
      /// 아이템 선택 시 스타일 제거
      self.sourceTableView.rx.itemSelected
         .subscribe(onNext: { [weak self] indexPath in
            self?.sourceTableView.deselectRow(at: indexPath, animated: true)
         })
         .disposed(by: disposeBag)
      
      /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
      self.sourceTableView.rx.modelSelected(MusicPlatform.self)
         .observe(on: MainScheduler.instance)
         .subscribe(onNext: { [weak self] platform in
            let transferDestinationVC = TransferDestinationViewController()
            transferDestinationVC.sourcePlatform = platform
            self?.navigationController?.pushViewController(transferDestinationVC, animated: true)
         })
         .disposed(by: disposeBag)
      
      /// TableView에 들어갈 Cell에 정보 제공
      self.sourceList
         .observe(on: MainScheduler.instance)
         .bind(to: self.sourceTableView.rx.items) { tableView, row, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: TransferTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! TransferTableViewCell
            cell.prepare(platform: item)
            return cell
         }
         .disposed(by: self.disposeBag)
   }
   
   private func setFromData() {
      self.loadPlubTableView.rx.setDelegate(self)
         .disposed(by: self.disposeBag)
      
      self.loadPlubTableView.rx.itemSelected
         .subscribe(onNext: { [weak self] indexPath in
            self?.loadPlubTableView.deselectRow(at: indexPath, animated: true)
         })
         .disposed(by: disposeBag)
      
      self.loadPlubTableView.rx.modelSelected(LoadPluv.self)
         .observe(on: MainScheduler.instance)
         .subscribe(onNext: { [weak self] platform in
            let transferDestinationVC = TransferDestinationViewController()
            transferDestinationVC.fromPlatform = platform
            self?.navigationController?.pushViewController(transferDestinationVC, animated: true)
         })
         .disposed(by: disposeBag)
      
      self.fromList
         .observe(on: MainScheduler.instance)
         .bind(to: self.loadPlubTableView.rx.items) { tableView, row, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadPluvTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! LoadPluvTableViewCell
            cell.prepare(from: item)
            return cell
         }
         .disposed(by: self.disposeBag)
   }
   
   @objc private func clickXButton() {
      if let navigationController = self.navigationController {
         let viewControllers = navigationController.viewControllers
         if viewControllers.count > 1 {
            let previousViewController = viewControllers[viewControllers.count - 2]
            navigationController.popToViewController(previousViewController, animated: true)
         }
      }
   }
}

extension TransferSourceViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      if tableView.tag == 1 {
         return 92
      } else {
         return 92
      }
   }
}
