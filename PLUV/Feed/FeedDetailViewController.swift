//
//  FeedDetailViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol SaveMoveViewDelegate: AnyObject {
   func setFeedSaveAPI()
}

class FeedDetailViewController: UIViewController, SaveMoveViewDelegate {
   
   private var viewModel = FeedViewModel()
   
   private let scrollView = UIScrollView()
   private let contentView = UIView()
   
   private let navigationbarView = NavigationBarView(title: "")
   
   private let feedDetailImageView = UIImageView()
   private let feedDetailTitleView = UIView()
   private let playlistTitleImageView = UIImageView().then {
      $0.image = UIImage(named: "menu_image")
   }
   private let playlistTitleLabel = UILabel().then {
      $0.numberOfLines = 0
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 22, weight: .semibold)
   }
   private let songCountAndDateLabel = UILabel().then {
      $0.textColor = .gray600
      $0.font = .systemFont(ofSize: 14)
   }
   private let sharePersonNameLabel = UILabel().then {
      $0.textColor = .gray800
      $0.font = .systemFont(ofSize: 16, weight: .medium)
   }
   private let separateLine = UIView().then {
      $0.backgroundColor = .gray200
   }
   
   private var feedDetailTableView = UITableView().then {
      $0.separatorStyle = .none
      $0.register(FeedDetailTableViewCell.self, forCellReuseIdentifier: FeedDetailTableViewCell.identifier)
   }
   
   private var feedDetailTableViewHeightConstraint: Constraint?
   
   private var saveMoveView = SaveMoveView(view: UIViewController())
   
   private let disposeBag = DisposeBag()
   
   init(viewModel: FeedViewModel) {
      super.init(nibName: nil, bundle: nil)
      self.viewModel = viewModel
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
      setPlaylistData()
      setFeedDetailMusicItemAPI()
   }
   
//   override func viewDidLayoutSubviews() {
//      super.viewDidLayoutSubviews()
//      setTableViewHeight() /// 레이아웃이 갱신될 때마다 테이블 뷰 높이 갱신
//   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      scrollView.showsVerticalScrollIndicator = false
      
      self.view.addSubview(scrollView)
      scrollView.snp.makeConstraints { make in
         make.top.bottom.leading.trailing.equalToSuperview()
      }
      
      self.scrollView.addSubview(contentView)
      contentView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
         make.width.equalTo(scrollView)
      }
      
      navigationbarView.delegate = self
      self.view.addSubview(navigationbarView)
      navigationbarView.snp.makeConstraints { make in
         make.top.equalToSuperview()
         make.leading.trailing.equalToSuperview()
         make.height.equalTo(93)
      }
      
      self.contentView.addSubview(feedDetailImageView)
      feedDetailImageView.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(46)
         make.leading.trailing.equalTo(contentView)
         make.height.equalTo(feedDetailImageView.snp.width) /// 정사각형 비율
      }
      
      self.contentView.addSubview(feedDetailTitleView)
      feedDetailTitleView.snp.makeConstraints { make in
         make.top.equalTo(feedDetailImageView.snp.bottom)
         make.leading.trailing.equalTo(contentView)
         make.height.equalTo(132)
      }
      
      self.feedDetailTitleView.addSubview(playlistTitleImageView)
      playlistTitleImageView.snp.makeConstraints { make in
         make.top.leading.equalToSuperview().inset(24)
         make.width.height.equalTo(20)
      }
      
      self.feedDetailTitleView.addSubview(playlistTitleLabel)
      playlistTitleLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(24)
         make.leading.equalTo(playlistTitleImageView.snp.trailing).offset(8)
         make.height.equalTo(24)
         make.trailing.equalToSuperview().inset(24)
      }
      
      self.feedDetailTitleView.addSubview(songCountAndDateLabel)
      songCountAndDateLabel.snp.makeConstraints { make in
         make.top.equalTo(playlistTitleLabel.snp.bottom).offset(20)
         make.leading.trailing.equalToSuperview().inset(24)
         make.height.equalTo(14)
      }
      
      self.feedDetailTitleView.addSubview(sharePersonNameLabel)
      sharePersonNameLabel.snp.makeConstraints { make in
         make.top.equalTo(songCountAndDateLabel.snp.bottom).offset(10)
         make.leading.trailing.bottom.equalToSuperview().inset(24)
      }
      
      self.feedDetailTitleView.addSubview(separateLine)
      separateLine.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.height.equalTo(1)
      }
      
      self.contentView.addSubview(feedDetailTableView)
      feedDetailTableView.snp.makeConstraints { make in
         make.top.equalTo(feedDetailTitleView.snp.bottom).offset(10)
         make.leading.trailing.bottom.equalToSuperview()
         feedDetailTableViewHeightConstraint = make.height.equalTo(0).constraint
      }
      
      feedDetailTableView.isScrollEnabled = false /// 테이블 뷰 스크롤 비활성화
      
      saveMoveView = SaveMoveView(view: self)
      self.view.addSubview(saveMoveView)
      saveMoveView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.height.equalTo(101)
      }
   }
   
   private func setTableViewHeight() {
      let contentHeight = feedDetailTableView.contentSize.height
      feedDetailTableViewHeightConstraint?.update(offset: contentHeight + 300)
      
      /// 이미지 높이 + 테이블 뷰 높이를 합산하여 스크롤뷰의 contentSize 설정
      let totalHeight = feedDetailImageView.frame.height + feedDetailTitleView.frame.height + 10 + contentHeight + 101
      scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
      scrollView.layoutIfNeeded()
   }
   
   private func setPlaylistData() {
      guard let selectFeedItem = self.viewModel.selectFeedItem else { return }
      let urlString = selectFeedItem.thumbNailURL
      let thumbnailURL = URL(string: urlString)
      let playlistTitle = selectFeedItem.title
      let songCount = String(describing: selectFeedItem.totalSongCount!)
      let date = String(describing: selectFeedItem.transferredAt)
      let person = String(describing: selectFeedItem.creatorName)
      
      feedDetailImageView.kf.setImage(with: thumbnailURL)
      playlistTitleLabel.text = playlistTitle
      songCountAndDateLabel.text = "총 \(songCount)곡  \(date)"
      sharePersonNameLabel.text = "공유한 사람 : \(person)"
   }
   
   private func setFeedDetailMusicItemAPI() {
      guard let id = self.viewModel.selectFeedItem?.id else { return }
      let url = EndPoint.feedIdMusic(String(id)).path
      
      APIService().get(of: APIResponse<[Music]>.self, url: url) { response in
         switch response.code {
         case 200:
            self.viewModel.selectFeedMusicItem.accept(response.data)
            self.setData()
         default:
            AlertController(message: response.msg).show()
         }
      }
   }
   
   private func setData() {
      self.feedDetailTableView.rx.setDelegate(self)
         .disposed(by: self.disposeBag)
      
      /// TableView에 들어갈 Cell에 정보 제공
      self.viewModel.selectFeedMusicItem
         .observe(on: MainScheduler.instance)
         .bind(to: self.feedDetailTableView.rx.items(cellIdentifier: FeedDetailTableViewCell.identifier, cellType: FeedDetailTableViewCell.self)) { index, music, cell in
            cell.prepare(music: music, index: index)
         }
         .disposed(by: disposeBag)
      
      /// 데이터 로드 후 레이아웃 강제 업데이트
      DispatchQueue.main.async {
         self.feedDetailTableView.reloadData()
         self.feedDetailTableView.layoutIfNeeded()
         self.setTableViewHeight()
      }
   }
   
   func setFeedSaveAPI() {
      
   }
}


extension FeedDetailViewController: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
