//
//  ValidationSimilarViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ValidationSimilarViewController: UIViewController {
   
   private let scrollView = UIScrollView()
   private let contentView = UIView()
   
   private let similarTitleView = UIView()
   private let sourceToDestinationLabel = UILabel().then {
      $0.text = "Spotify > AppleMusic"
      $0.font = .systemFont(ofSize: 14, weight: .regular)
      $0.textColor = .gray800
   }
   private let backButton = UIButton().then {
      $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
   }
   private let similarTitleLabel1 = UILabel().then {
      $0.text = "가장 유사한 항목을 옮길까요?"
      $0.font = .systemFont(ofSize: 24, weight: .semibold)
      $0.textColor = .gray800
   }
   private let similarTitleLabel2 = UILabel().then {
      $0.text = "원곡과 일부 정보가 일치하는 음악이에요"
      $0.font = .systemFont(ofSize: 16, weight: .medium)
      $0.textColor = .gray600
   }
   private let similarSongView = UIView()
   private let songCountLabel = UILabel().then {
      $0.text = "3곡"
      $0.textColor = .gray700
      $0.font = .systemFont(ofSize: 14)
   }
   private let similarMusicTableView = UITableView().then {
      $0.separatorStyle = .none
      $0.register(ValidationSimilarTableViewCell.self, forCellReuseIdentifier: ValidationSimilarTableViewCell.identifier)
      $0.backgroundColor = .gray200
   }
   private var moveView = MoveView(view: UIViewController())
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
      
      self.contentView.addSubview(similarTitleView)
      similarTitleView.snp.makeConstraints { make in
         make.leading.top.trailing.equalToSuperview()
         make.height.equalTo(203)
      }
      
      self.similarTitleView.addSubview(sourceToDestinationLabel)
      sourceToDestinationLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(47)
         make.leading.equalToSuperview().inset(24)
         make.height.equalTo(46)
      }
      
      self.similarTitleView.addSubview(backButton)
      backButton.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(47)
         make.trailing.equalToSuperview().inset(14)
         make.height.equalTo(46)
         make.width.equalTo(46)
      }
      backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
      
      self.similarTitleView.addSubview(similarTitleLabel1)
      similarTitleLabel1.snp.makeConstraints { make in
         make.top.equalTo(sourceToDestinationLabel.snp.bottom).offset(28)
         make.leading.equalToSuperview().inset(24)
      }
      
      self.similarTitleView.addSubview(similarTitleLabel2)
      similarTitleLabel2.snp.makeConstraints { make in
         make.top.equalTo(similarTitleLabel1.snp.bottom).offset(8)
         make.leading.trailing.equalToSuperview().inset(24)
      }
      
      self.contentView.addSubview(similarSongView)
      similarSongView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.top.equalTo(similarTitleView.snp.bottom)
      }
      
      self.similarSongView.addSubview(songCountLabel)
      songCountLabel.snp.makeConstraints { make in
         make.top.equalToSuperview()
         make.leading.equalToSuperview().offset(24)
         make.height.equalTo(38)
      }
      
      self.similarSongView.addSubview(similarMusicTableView)
      similarMusicTableView.snp.makeConstraints { make in
         make.top.equalTo(songCountLabel.snp.bottom)
         make.leading.trailing.bottom.equalToSuperview()
      }
      
      moveView = MoveView(view: self)
      self.view.addSubview(moveView)
      moveView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.height.equalTo(102)
      }
   }
   
   @objc private func clickXButton() {
      if let navigationController = self.navigationController {
         let viewControllers = navigationController.viewControllers
         if viewControllers.count > 5 {
            let previousViewController = viewControllers[viewControllers.count - 7]
            navigationController.popToViewController(previousViewController, animated: true)
         }
      }
   }
}

extension ValidationSimilarViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 194
   }
}
