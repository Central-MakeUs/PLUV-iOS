//
//  SaveDetailViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SaveDetailViewController: UIViewController {
   
   private let scrollView = UIScrollView()
   private let contentView = UIView()
   
   private let navigationbarView = NavigationBarView(title: "")
   private let thumbnailImageView = UIImageView().then {
       $0.clipsToBounds = true
   }
   private let menuImageView = UIImageView().then {
      $0.image = UIImage(named: "menu_image")
   }
   private let playlistTitleLabel = UILabel().then {
      $0.text = "여유로운 오후의 취향 저격 팝"
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 18, weight: .semibold)
   }
   private let totalCountLabel = UILabel().then {
      $0.text = "총 10곡"
      $0.textColor = .gray600
      $0.font = .systemFont(ofSize: 14, weight: .regular)
   }
   private let dateLabel = UILabel().then {
      $0.text = "2023.03.01"
      $0.textColor = .gray600
      $0.font = .systemFont(ofSize: 14, weight: .regular)
   }
   private let creatorLabel = UILabel().then {
      $0.text = "공유한 사람: 플러버"
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 16, weight: .medium)
   }
   private let backgroundLabel = UILabel().then {
      $0.backgroundColor = .gray200
   }
   private let saveSongsTableViewCell = UITableView().then {
      $0.separatorStyle = .none
      $0.register(SaveSongsTableViewCell.self, forCellReuseIdentifier: SaveSongsTableViewCell.identifier)
   }
   private var saveMoveView = SaveMoveView(view: UIViewController())
   
   private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

       setUI()
    }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      scrollView.contentInsetAdjustmentBehavior = .never
      scrollView.showsVerticalScrollIndicator = false
      
      self.view.addSubview(scrollView)
      scrollView.snp.makeConstraints { make in
         make.top.bottom.leading.trailing.equalToSuperview()
      }
      
      self.scrollView.addSubview(contentView)
      contentView.snp.makeConstraints { make in
         make.edges.equalTo(scrollView.contentLayoutGuide)
         make.width.equalTo(scrollView.frameLayoutGuide)
         make.height.equalTo(1100)
      }
      
      self.contentView.addSubview(navigationbarView)
      navigationbarView.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(47)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(46)
      }
      navigationbarView.setBackButtonTarget(target: self)
      
      self.contentView.addSubview(thumbnailImageView)
      thumbnailImageView.snp.makeConstraints { make in
         make.top.equalTo(navigationbarView.snp.bottom)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(390)
      }
      
      self.contentView.addSubview(menuImageView)
      menuImageView.snp.makeConstraints { make in
         make.top.equalTo(thumbnailImageView.snp.bottom).offset(26)
         make.leading.equalToSuperview().inset(24)
         make.width.equalTo(20)
         make.height.equalTo(20)
      }
      
      self.contentView.addSubview(playlistTitleLabel)
      playlistTitleLabel.snp.makeConstraints { make in
         make.top.equalTo(thumbnailImageView.snp.bottom).offset(24)
         make.leading.equalTo(menuImageView.snp.trailing).offset(8)
         make.height.equalTo(24)
      }
      
      self.contentView.addSubview(totalCountLabel)
      totalCountLabel.snp.makeConstraints { make in
         make.top.equalTo(menuImageView.snp.bottom).offset(14)
         make.leading.equalToSuperview().inset(24)
         make.height.equalTo(14)
      }
      
      self.contentView.addSubview(dateLabel)
      dateLabel.snp.makeConstraints { make in
         make.top.equalTo(menuImageView.snp.bottom).offset(14)
         make.leading.equalTo(totalCountLabel.snp.trailing).offset(8)
         make.height.equalTo(14)
      }
      
      self.contentView.addSubview(creatorLabel)
      creatorLabel.snp.makeConstraints { make in
         make.top.equalTo(totalCountLabel.snp.bottom).offset(10)
         make.leading.equalToSuperview().inset(24)
         make.height.equalTo(16)
      }
      
      self.contentView.addSubview(backgroundLabel)
      backgroundLabel.snp.makeConstraints { make in
         make.top.equalTo(creatorLabel.snp.bottom).offset(34)
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(1.2)
      }
      
      self.contentView.addSubview(saveSongsTableViewCell)
      saveSongsTableViewCell.snp.makeConstraints { make in
         make.top.equalTo(backgroundLabel.snp.bottom).offset(10)
         make.leading.trailing.bottom.equalToSuperview()
      }
      
      saveMoveView = SaveMoveView(view: self)
      self.view.addSubview(saveMoveView)
      saveMoveView.snp.makeConstraints { make in
          make.leading.trailing.bottom.equalToSuperview()
          make.height.equalTo(102)
      }
   }
}

extension SaveDetailViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
