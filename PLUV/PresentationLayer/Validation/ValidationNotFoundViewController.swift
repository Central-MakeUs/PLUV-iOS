//
//  ValidationNotFoundViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ValidationNotFoundViewController: UIViewController {
   
   var completeArr: [String] = []
   var failArr = BehaviorRelay<[SearchMusic]>(value: [])
   
   var sourcePlatform: PlatformRepresentable?
   var destinationPlatform: MusicPlatform = .Spotify
   
   private let notFoundTitleView = UIView()
   private let sourceToDestinationLabel = UILabel().then {
      $0.font = .systemFont(ofSize: 14, weight: .regular)
      $0.textColor = .gray800
   }
   private let backButton = UIButton().then {
      $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
   }
   private let progressView = CustomProgressView()
   private let notFoundTitleLabel1 = UILabel().then {
      $0.text = "애플 뮤직에서\n찾을 수 없는 음악이에요"
      $0.font = .systemFont(ofSize: 24, weight: .semibold)
      $0.textColor = .gray800
   }
   private let notFoundSongView = UIView()
   private let songCountLabel = UILabel().then {
      $0.text = "3곡"
      $0.textColor = .gray700
      $0.font = .systemFont(ofSize: 14)
   }
   private let backgroundLabel = UILabel().then {
      $0.backgroundColor = .gray200
   }
   private let notFoundMusicTableView = UITableView().then {
      $0.separatorStyle = .none
      $0.register(ValidationNotFoundTableViewCell.self, forCellReuseIdentifier: ValidationNotFoundTableViewCell.identifier)
      $0.backgroundColor = .gray200
      $0.contentInset = UIEdgeInsets(top: 1.2, left: 0, bottom: 0, right: 0)
      $0.sectionFooterHeight = 1.2
   }
   private var moveView = MoveView(view: UIViewController())
   private let disposeBag = DisposeBag()
   
    init(completeArr: [String], failArr: BehaviorRelay<[SearchMusic]>, source: PlatformRepresentable, destination: MusicPlatform) {
       super.init(nibName: nil, bundle: nil)
        self.completeArr = completeArr
        self.failArr = failArr
        self.sourcePlatform = source
        self.destinationPlatform = destination
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      self.view.addSubview(notFoundTitleView)
      notFoundTitleView.snp.makeConstraints { make in
         make.leading.top.trailing.equalToSuperview()
         make.height.equalTo(213)
      }
      
      self.notFoundTitleView.addSubview(sourceToDestinationLabel)
      sourceToDestinationLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(47)
         make.leading.equalToSuperview().inset(24)
         make.height.equalTo(46)
      }
      
      self.notFoundTitleView.addSubview(backButton)
      backButton.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(53)
         make.trailing.equalToSuperview().inset(20)
         make.height.equalTo(34)
         make.width.equalTo(34)
      }
      backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
      
      self.notFoundTitleView.addSubview(progressView)
      progressView.snp.makeConstraints { make in
         make.top.equalTo(backButton.snp.bottom).offset(6)
         make.trailing.leading.equalToSuperview()
         make.height.equalTo(4)
      }
      progressView.updateProgress(to: 0.875)
      
      self.notFoundTitleView.addSubview(notFoundTitleLabel1)
      notFoundTitleLabel1.snp.makeConstraints { make in
         make.top.equalTo(progressView.snp.bottom).offset(24)
         make.leading.equalToSuperview().inset(24)
      }
      
      self.view.addSubview(notFoundSongView)
      notFoundSongView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.top.equalTo(notFoundTitleView.snp.bottom)
      }
      
      self.notFoundSongView.addSubview(songCountLabel)
      songCountLabel.snp.makeConstraints { make in
         make.top.equalToSuperview()
         make.leading.equalToSuperview().offset(24)
         make.height.equalTo(38)
      }
      
      self.notFoundSongView.addSubview(backgroundLabel)
      backgroundLabel.snp.makeConstraints { make in
         make.top.equalTo(songCountLabel.snp.bottom)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(1.2)
      }
      
      self.notFoundSongView.addSubview(notFoundMusicTableView)
      notFoundMusicTableView.snp.makeConstraints { make in
         make.top.equalTo(songCountLabel.snp.bottom)
         make.leading.trailing.bottom.equalToSuperview()
      }
      
      moveView = MoveView(view: self)
      self.view.addSubview(moveView)
      moveView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.height.equalTo(102)
      }
      moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
   }
    
    private func setFailData() {
        notFoundMusicTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.failArr
            .observe(on: MainScheduler.instance)
            .bind(to: self.notFoundMusicTableView.rx.items(cellIdentifier: ValidationNotFoundTableViewCell.identifier, cellType: ValidationNotFoundTableViewCell.self)) { index, item, cell in
                cell.prepare(music: item)
            }
            .disposed(by: disposeBag)
    }
   
   @objc private func clickXButton() {
      if let navigationController = self.navigationController {
         let viewControllers = navigationController.viewControllers
         if viewControllers.count > 5 {
            let previousViewController = viewControllers[viewControllers.count - 8]
            navigationController.popToViewController(previousViewController, animated: true)
         }
      }
   }
   
   @objc private func clickTransferButton() {
      let movePlaylistVC = MovePlaylistViewController(musicArr: completeArr, source: sourcePlatform!, destination: destinationPlatform)
      self.navigationController?.pushViewController(movePlaylistVC, animated: true)
   }
}

extension ValidationNotFoundViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 68
   }
}
