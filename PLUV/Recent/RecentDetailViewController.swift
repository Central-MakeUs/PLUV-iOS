//
//  RecentClassifyViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Tabman
import Pageboy
import Alamofire

class RecentDetailViewController: UIViewController {
    
    var recentData: HistoryInfo!
    private var viewModel = MeViewModel()
    
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
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    private let classifyView = UIView().then {
        $0.backgroundColor = .white
    }
    private let moveView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 2
        $0.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    private let moveButton = UIButton().then {
        $0.setTitle("플레이리스트 옮기기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: MeViewModel) {
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
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
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
        
        self.contentView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(totalCountLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1.2)
        }
        
        self.contentView.addSubview(classifyView)
        classifyView.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        let childVC = RecentTabViewController(viewModel: self.viewModel)
        addChild(childVC)
        classifyView.addSubview(childVC.view)
        childVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        childVC.didMove(toParent: self)
        
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(102)
        }
        
        self.moveView.addSubview(moveButton)
        moveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(58)
        }
    }
    
    @objc func transferButtonTapped() {
        let transferDestinationVC = TransferDestinationViewController()
        transferDestinationVC.fromPlatform = LoadPluv.FromRecent
        transferDestinationVC.feedViewModel.meItem = viewModel.selectMeItem
        self.navigationController?.pushViewController(transferDestinationVC, animated: true)
    }
    
    private func setPlaylistData() {
        guard let selectMeItem = self.viewModel.selectMeItem else { return }
        let urlString = selectMeItem.imageURL
        let thumbnailURL = URL(string: urlString)
        let playlistTitle = selectMeItem.title
        let songCount = String(describing: selectMeItem.transferredSongCount)
        let date = String(describing: selectMeItem.transferredDate)
        
        thumbnailImageView.kf.setImage(with: thumbnailURL)
        playlistTitleLabel.text = playlistTitle
        totalCountLabel.text = "총 \(songCount)곡"
        dateLabel.text = "\(date)"
    }
}
