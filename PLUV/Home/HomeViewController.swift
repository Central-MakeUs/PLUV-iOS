//
//  HomeViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/9/24.
//

import UIKit
import StoreKit
import SnapKit
import Then
import MusicKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    let meViewModel = MeViewModel()
    let saveViewModel = SaveViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backgroundhome_image")
    }
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "homelogo_image")
        $0.contentMode = .scaleAspectFill
    }
    private let transferDirectButton = UIButton().then {
        $0.setImage(UIImage(named: "homebutton_direct_image"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let transferScreenshotButton = UIButton().then {
        $0.setImage(UIImage(named: "homebutton_screenshot_image"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    private let myPlaylistImageView = UIImageView().then {
        $0.image = UIImage(named: "myplaylist_image")
    }
    private let recentListView = UIView().then {
        $0.backgroundColor = .white
    }
    private let recentListLabel = UILabel().then {
        $0.text = "최근 옮긴 항목"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .gray800
    }
    private let recentListButton = UIButton().then {
        $0.setImage(UIImage(named: "nextbutton_icon"), for: .normal)
        $0.setTitle("전체보기 ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(.gray600, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private var recentPlayListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: RecentCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    private let recentEmptyLabel = UILabel().then {
        $0.text = "최근 옮긴 항목이 없습니다."
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .gray400
        $0.textAlignment = .center
    }
    private let saveListView = UIView().then {
        $0.backgroundColor = .white
    }
    private let saveListLabel = UILabel().then {
        $0.text = "저장한 플레이리스트"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .gray800
    }
    private let saveListButton = UIButton().then {
        $0.setImage(UIImage(named: "nextbutton_icon"), for: .normal)
        $0.setTitle("전체보기 ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(.gray600, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private var savePlayListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SaveCollectionViewCell.self, forCellWithReuseIdentifier: SaveCollectionViewCell.identifier)
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    private let saveEmptyLabel = UILabel().then {
        $0.text = "저장한 플레이리스트가 없습니다."
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .gray400
        $0.textAlignment = .center
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setMeAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 표시하기
        self.tabBarController?.tabBar.isHidden = false
        setSaveAPI()
    }
}

extension HomeViewController {
    
    private func setUI() {
        self.view.backgroundColor = .gray100
        self.navigationItem.setHidesBackButton(true, animated: false)
        
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
            make.height.equalTo(940)
        }
        
        self.contentView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(359)
        }
        
        self.contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(62)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(66)
            make.height.equalTo(24)
        }
        
        self.contentView.addSubview(transferDirectButton)
        transferDirectButton.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(112)
        }
        transferDirectButton.addTarget(self, action: #selector(clickTransferDirectButton), for: .touchUpInside)
        
        self.contentView.addSubview(transferScreenshotButton)
        transferScreenshotButton.snp.makeConstraints { make in
            make.top.equalTo(transferDirectButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(112)
        }
        transferScreenshotButton.addTarget(self, action: #selector(clickTransferScreenshotButton), for: .touchUpInside)
        
        self.contentView.addSubview(myPlaylistImageView)
        myPlaylistImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        
        self.contentView.addSubview(recentListView)
        recentListView.snp.makeConstraints { make in
            make.top.equalTo(myPlaylistImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(230)
        }
        
        self.recentListView.addSubview(recentListLabel)
        recentListLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        self.recentListView.addSubview(recentListButton)
        recentListButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        recentListButton.addTarget(self, action: #selector(clickRecentListButton), for: .touchUpInside)
        
        self.recentListView.addSubview(recentPlayListCollectionView)
        recentPlayListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recentListLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        self.contentView.addSubview(saveListView)
        saveListView.snp.makeConstraints { make in
            make.top.equalTo(recentListView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(190)
        }
        
        self.saveListView.addSubview(saveListLabel)
        saveListLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        self.saveListView.addSubview(saveListButton)
        saveListButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        saveListButton.addTarget(self, action: #selector(clickSaveListButton), for: .touchUpInside)
        
        self.saveListView.addSubview(savePlayListCollectionView)
        savePlayListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(saveListLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    @objc private func clickTransferDirectButton() {
        let transferSourceViewController = TransferSourceViewController()
        self.navigationController?.pushViewController(transferSourceViewController, animated: true)
    }
    
    @objc private func clickTransferScreenshotButton() {
        AlertController(message: "추후 공개될 예정이에요!").show()
    }
    
    @objc private func clickRecentListButton() {
        let recentViewController = RecentViewController()
        recentViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(recentViewController, animated: true)
    }
    
    @objc private func clickSaveListButton() {
        let saveViewController = SaveViewController()
        saveViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(saveViewController, animated: true)
    }
    
    /// 테스트
    private func setTestAppleMusic() {
        MusicKitManager.shared.fetchMusic("알레프")
    }
    
    private func setMeEmptyLabel() {
        self.recentListView.addSubview(recentEmptyLabel)
        recentEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(recentListLabel.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
    }
    
    private func setSaveEmptyLabel() {
        self.saveListView.addSubview(saveEmptyLabel)
        saveEmptyLabel.snp.makeConstraints { make in
            make.top.equalTo(saveListLabel.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
    }
    
    private func setMeData() {
        recentPlayListCollectionView.rx.setDelegate(self)
                .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.meViewModel.meItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.recentPlayListCollectionView.rx.items(cellIdentifier: RecentCollectionViewCell.identifier, cellType: RecentCollectionViewCell.self)) { index, item, cell in
                cell.prepare(me: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setMeAPI() {
       let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
       let url = EndPoint.historyMe.path
       
       APIService().getWithAccessToken(of: APIResponse<[Me]>.self, url: url, AccessToken: loginToken) { response in
          switch response.code {
          case 200:
              if response.data.isEmpty {
                  self.recentPlayListCollectionView.isHidden = true
                  self.setMeEmptyLabel()
              } else {
                  self.recentPlayListCollectionView.isHidden = false
                  self.recentEmptyLabel.removeFromSuperview()
                  let limitedData = Array(response.data.prefix(5))
                  self.meViewModel.meItems = Observable.just(limitedData)
                  self.setMeData()
                  self.view.layoutIfNeeded()
              }
          default:
             AlertController(message: response.msg).show()
          }
       }
    }
    
    private func setSaveData() {
        savePlayListCollectionView.delegate = nil
        savePlayListCollectionView.dataSource = nil
        
        savePlayListCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.saveViewModel.saveItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.savePlayListCollectionView.rx.items(cellIdentifier: SaveCollectionViewCell.identifier, cellType: SaveCollectionViewCell.self)) { index, item, cell in
                cell.prepare(feed: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func setSaveAPI() {
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        let url = EndPoint.feedSave.path
        
        APIService().getWithAccessToken(of: APIResponse<[Feed]>.self, url: url, AccessToken: loginToken) { response in
            switch response.code {
            case 200:
                if response.data.isEmpty {
                    self.savePlayListCollectionView.isHidden = true
                    self.setSaveEmptyLabel()
                } else {
                    self.savePlayListCollectionView.isHidden = false
                    self.saveEmptyLabel.removeFromSuperview()
                    self.saveViewModel.saveItems = Observable.just(response.data)
                    self.setSaveData()
                    self.view.layoutIfNeeded()
                }
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
}

@available(iOS 14.0, *)
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == recentPlayListCollectionView {
            return CGSize(width: 140, height: 140)
        } else if collectionView == savePlayListCollectionView {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
}
