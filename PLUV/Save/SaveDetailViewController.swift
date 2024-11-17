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
import Alamofire

protocol SaveMoveViewSaveDelegate: AnyObject {
    func deleteFeedSaveAPI()
}

class SaveDetailViewController: UIViewController, SaveMoveViewSaveDelegate {
   
    private var viewModel = SaveViewModel()
    private var saveViewModel = SaveViewModel()
   
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
    
    private var feedDetailTableViewHeightConstraint: Constraint?
    
   private var saveMoveView = SaveMoveView(view: UIViewController())
   
   private let disposeBag = DisposeBag()
   
    init(viewModel: SaveViewModel) {
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
        setSaveMusicAPI()
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
        
        navigationbarView.delegate = self
        self.view.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(93)
        }
        
        self.contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(93)
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
        saveSongsTableViewCell.isScrollEnabled = false
        
        saveMoveView = SaveMoveView(view: self)
        self.view.addSubview(saveMoveView)
        saveMoveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(102)
        }
        self.saveMoveView.saveDelegate = self
        self.saveMoveView.updateSaveButtonImage(isSaved: false)
    }
    
    private func setPlaylistData() {
        guard let selectSaveItem = self.viewModel.selectSaveItem else { return }
        let urlString = selectSaveItem.thumbNailURL
        let thumbnailURL = URL(string: urlString)
        let playlistTitle = selectSaveItem.title
        let songCount = String(describing: selectSaveItem.totalSongCount!)
        let date = String(describing: selectSaveItem.transferredAt)
        let person = String(describing: selectSaveItem.creatorName)
        
        thumbnailImageView.kf.setImage(with: thumbnailURL)
        playlistTitleLabel.text = playlistTitle
        totalCountLabel.text = "총 \(songCount)곡"
        dateLabel.text = "\(date)"
        creatorLabel.text = "공유한 사람 : \(person)"
    }
   
    private func setDetailData() {
        self.saveSongsTableViewCell.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.selectSaveMusicItem
            .observe(on: MainScheduler.instance)
            .bind(to: self.saveSongsTableViewCell.rx.items(cellIdentifier: SaveSongsTableViewCell.identifier, cellType: SaveSongsTableViewCell.self)) { index, item, cell in
                cell.prepare(music: item, index: index)
            }
            .disposed(by: disposeBag)
    }
   
    private func setSaveMusicAPI() {
        guard let id = self.viewModel.selectSaveItem?.id else { return }
        let url = EndPoint.feedIdMusic("\(id)").path
        
        APIService().get(of: APIResponse<[Music]>.self, url: url) { response in
            switch response.code {
            case 200:
                self.viewModel.selectSaveMusicItem.accept(response.data)
                self.setDetailData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
    
    func deleteFeedSaveAPI() {
       guard let id = self.viewModel.selectSaveItem?.id else { return }
       let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
       let url = EndPoint.feedIdSave(String(id)).path
       
       APIService().deleteWithAccessToken(of: APIResponse<String>.self, url: url, parameters: nil, AccessToken: loginToken) { response in
          switch response.code {
          case 200:
             print("피드 삭제가 정상적으로 처리되었습니다.")
              self.saveMoveView.updateSaveButton()
          default:
             AlertController(message: response.msg).show()
          }
       }
    }
}

extension SaveDetailViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
