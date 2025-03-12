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

protocol SaveMoveViewSaveDelegate: AnyObject {
    func setFeedSaveAPI()
    func deleteFeedSaveAPI()
    func transferFeedSave()
}

class SaveDetailViewController: UIViewController, SaveMoveViewSaveDelegate {
    
    private var viewModel = SaveViewModel()
    private let disposeBag = DisposeBag()
    
    private var saveDetailTableViewHeightConstraint: Constraint?
    private var saveMoveView = SaveMoveView(view: UIViewController())
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navigationbarView = NavigationBarView(title: "")
    private let thumbnailImageView = UIImageView()
    private let saveDetailTitleView = UIView()
    private let menuImageView = UIImageView().then {
        $0.image = UIImage(named: "menu_image")
    }
    private let playlistTitleLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
    }
    private let totalCountLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    private let creatorLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    private let saveDetailTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(SaveDetailTableViewCell.self, forCellReuseIdentifier: SaveDetailTableViewCell.identifier)
    }
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTableViewHeight()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        
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
        
        self.contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(46)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(390)
        }
        
        self.contentView.addSubview(saveDetailTitleView)
        saveDetailTitleView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(132)
        }
        
        self.saveDetailTitleView.addSubview(menuImageView)
        menuImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(24)
            make.width.height.equalTo(20)
        }
        
        self.saveDetailTitleView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalTo(menuImageView.snp.trailing).offset(8)
            make.height.equalTo(24)
            make.trailing.equalToSuperview().inset(24)
        }
        
        self.saveDetailTitleView.addSubview(totalCountLabel)
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(menuImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(14)
        }
        
        self.saveDetailTitleView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(menuImageView.snp.bottom).offset(20)
            make.leading.equalTo(totalCountLabel.snp.trailing).offset(8)
            make.height.equalTo(14)
        }
        
        self.saveDetailTitleView.addSubview(creatorLabel)
        creatorLabel.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(16)
        }
        
        self.saveDetailTitleView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1.2)
        }
        
        self.contentView.addSubview(saveDetailTableView)
        saveDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(saveDetailTitleView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            saveDetailTableViewHeightConstraint = make.height.equalTo(0).constraint
        }
        saveDetailTableView.isScrollEnabled = false
        
        saveMoveView = SaveMoveView(view: self)
        self.view.addSubview(saveMoveView)
        saveMoveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(102)
        }
        self.saveMoveView.saveDelegate = self
        self.saveMoveView.updateSaveButtonImage(isSaved: false)
    }
    
    private func setTableViewHeight() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let contentHeight = self.saveDetailTableView.contentSize.height + 110
            self.saveDetailTableViewHeightConstraint?.update(offset: contentHeight)
            
            /// 이미지 높이 + 테이블 뷰 높이를 합산하여 스크롤뷰의 contentSize 설정
            let totalHeight = self.navigationbarView.frame.height + self.thumbnailImageView.frame.height + self.saveDetailTitleView.frame.height + contentHeight
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: totalHeight)
            self.scrollView.layoutIfNeeded()
            self.scrollView.isScrollEnabled = true
        }
        CATransaction.commit()
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
        self.saveDetailTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.selectSaveMusicItem
            .observe(on: MainScheduler.instance)
            .bind(to: self.saveDetailTableView.rx.items(cellIdentifier: SaveDetailTableViewCell.identifier, cellType: SaveDetailTableViewCell.self)) { index, item, cell in
                cell.prepare(music: item, index: index)
            }
            .disposed(by: disposeBag)
        
        self.saveDetailTableView.reloadData()
        self.saveDetailTableView.layoutIfNeeded()
    }
    
    private func setSaveMusicAPI() {
        guard let id = self.viewModel.selectSaveItem?.id else { return }
        let url = EndPoint.feedIdMusic(String(id)).path
        
        APIService().get(of: APIResponse<[Music]>.self, url: url) { response in
            switch response.code {
            case 200:
                self.viewModel.selectSaveMusicItem.accept(response.data)
                self.setDetailData()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
    
    func setFeedSaveAPI() {
        guard let id = self.viewModel.selectSaveItem?.id else { return }
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        let url = EndPoint.feedIdSave(String(id)).path
        
        APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: nil, AccessToken: loginToken) { response in
            switch response.code {
            case 200:
                print("피드 저장이 정상적으로 처리되었습니다.")
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
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
    
    func transferFeedSave() {
        let transferDestinationVC = TransferDestinationViewController()
        transferDestinationVC.fromPlatform = LoadPluv.FromSave
        transferDestinationVC.saveViewModel.saveItem = viewModel.selectSaveItem!
        self.navigationController?.pushViewController(transferDestinationVC, animated: true)
    }
}

extension SaveDetailViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
