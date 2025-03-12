//
//  FeedViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FeedViewController: UIViewController {
    
    private let viewModel = FeedViewModel()
    private let disposeBag = DisposeBag()
    
    private let titleView = UIView()
    private let feedTitleLabel = UILabel().then {
        $0.text = "최신 플레이리스트"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    private var feedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 14
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setFeedAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        self.titleView.addSubview(feedTitleLabel)
        feedTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(28)
        }
        
        self.view.addSubview(feedCollectionView)
        feedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(82)
        }
        feedCollectionView.showsVerticalScrollIndicator = false
        feedCollectionView.allowsMultipleSelection = false
    }
    
    private func setData() {
        self.feedCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.viewModel.feedItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.feedCollectionView.rx.items(cellIdentifier: FeedCollectionViewCell.identifier, cellType: FeedCollectionViewCell.self)) { index, item, cell in
                cell.prepare(feed: item)
            }
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
        self.feedCollectionView.rx.modelSelected(Feed.self)
            .subscribe(onNext: { [weak self] feedItem in
                guard let self = self else { return }
                self.viewModel.selectFeedItem = feedItem
                let feedDetailVC = FeedDetailViewController(viewModel: self.viewModel)
               feedDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(feedDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setFeedAPI() {
        let url = EndPoint.feed.path
        
        APIService().get(of: APIResponse<[Feed]>.self, url: url) { response in
            switch response.code {
            case 200:
                self.viewModel.feedItems = Observable.just(response.data)
                self.setData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
}

@available(iOS 14.0, *)
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
        return CGSize(width: value, height: value / 172 * 272)
    }
}
