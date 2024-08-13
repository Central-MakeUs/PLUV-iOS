//
//  TransferPlaylistViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TransferPlaylistViewController: UIViewController {
    
    var playlistItem: Observable<[SpotifyPlaylist]> = Observable.just([])
    
    private let playlistTitleView = UIView()
    private let sourceToDestinationLabel = UILabel().then {
        $0.text = "스포티파이 > 애플뮤직"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .subBlue
    }
    private let playlistTitleLabel = UILabel().then {
        $0.text = "어떤 플레이리스트를 옮길까요?"
        $0.font = .systemFont(ofSize: 24, weight: .regular)
        $0.textColor = .gray800
    }
    private let maximumCountLabel = UILabel().then {
        $0.text = "최대 1개"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .gray600
    }
    private let playlistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 30, right: 15)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TransferPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: TransferPlaylistCollectionViewCell.identifier)
        
        return cv
    }()
    
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setPlaylist()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(playlistTitleView)
        playlistTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(124)
        }
        
        self.playlistTitleView.addSubview(sourceToDestinationLabel)
        sourceToDestinationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(14)
        }
        
        self.playlistTitleView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceToDestinationLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(28)
        }
        
        self.view.addSubview(maximumCountLabel)
        maximumCountLabel.snp.makeConstraints { make in
            make.top.equalTo(playlistTitleView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        self.view.addSubview(playlistCollectionView)
        playlistCollectionView.snp.makeConstraints { make in
            make.top.equalTo(maximumCountLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        playlistCollectionView.showsVerticalScrollIndicator = false
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
            make.top.equalTo(playlistCollectionView.snp.bottom)
        }
    }
    
    private func setData() {
        self.playlistCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.playlistItem
            .observe(on: MainScheduler.instance)
            .bind(to: self.playlistCollectionView.rx.items(cellIdentifier: TransferPlaylistCollectionViewCell.identifier, cellType: TransferPlaylistCollectionViewCell.self)) { index, item, cell in
                cell.prepare(playlist: item)
            }
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
        self.playlistCollectionView.rx.modelSelected(SpotifyPlaylist.self)
            .subscribe(onNext: { [weak self] playlistItem in
                //
            })
            .disposed(by: disposeBag)
    }
    
    private func setPlaylist() {
        let url = EndPoint.playlistSpotifyRead.path
        let params = ["accessToken" : "BQCgliukvY3HAdA05-bAnU4S94C4rANNRhsihm3UTtScADYZVDXDw9cAi47joVsxxnNmlsBAVJIh1TekEeNiQG_bPY1dTKKEZ_026VxPGuTvMuBHcY78egmq6zMJriJlzqGWQZEHmzUxI_pqzp5Cy9BERcndtUKgxdmua1VxbItcIZMxA2JKrqkcp5mE4kIRGOdi-vjbTKw9TA7zPSnFIUdO3ysxJ7M0rOanuy-3D5SwNSx1RPNsrkZ8I4Nb_nmH_JxXs-J_nf1lN4bhBx_jDK5Q74cGuEsgaKGG-xWtvwxqupfk8G0KmYrfRqi2iIhDm761bVT67yIFV4tvJ2sSmQ"]
        
        APIService().post(of: [SpotifyPlaylist].self, url: url, parameters: params) { response in
            self.playlistItem = Observable.just(response)
            self.setData()
        }
    }
}

@available(iOS 14.0, *)
extension TransferPlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
        return CGSize(width: value, height: value / 140 * 188)
    }
}
