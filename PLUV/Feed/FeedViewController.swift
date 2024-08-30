//
//  FeedViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let titleView = UIView()
    private let feedTitleLabel = UILabel().then {
        $0.text = "최신 플레이리스트"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    private var feedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SelectPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: SelectPlaylistCollectionViewCell.identifier)
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
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
            make.bottom.equalToSuperview().inset(80)
        }
        feedCollectionView.showsVerticalScrollIndicator = false
        feedCollectionView.allowsMultipleSelection = false
    }
}
