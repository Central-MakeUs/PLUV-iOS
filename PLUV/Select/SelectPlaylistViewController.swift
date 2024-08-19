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
import MusicKit

class SelectPlaylistViewController: UIViewController {
    
    let viewModel = SelectPlaylistViewModel()
    
    private var sourcePlatform: MusicPlatform = .AppleMusic
    private var destinationPlatform: MusicPlatform = .Spotify
    
    private let playlistTitleView = UIView()
    private let sourceToDestinationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .subBlue
    }
    private let playlistTitleLabel = UILabel().then {
        $0.text = "어떤 플레이리스트를 옮길까요?"
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
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
        cv.register(SelectPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: SelectPlaylistCollectionViewCell.identifier)
        
        return cv
    }()
    
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
    init(source: MusicPlatform, destination: MusicPlatform) {
        super.init(nibName: nil, bundle: nil)
        self.sourcePlatform = source
        self.destinationPlatform = destination
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setPlaylistAPI()
        setCellSelected()
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
        
        sourceToDestinationLabel.text = sourcePlatform.name + " > " + destinationPlatform.name
        
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
        playlistCollectionView.allowsMultipleSelection = false
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
            make.top.equalTo(playlistCollectionView.snp.bottom)
        }
        
        moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
    }
    
    @objc private func clickTransferButton() {
        let selectMusicVC = SelectMusicViewController()
        self.navigationController?.pushViewController(selectMusicVC, animated: true)
    }
    
    private func setCellSelected() {
        // 셀 선택 시
        self.playlistCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                // 현재 선택된 셀을 ViewModel에 업데이트
                self.viewModel.selectedIndexPath.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
        // 셀 선택 해제 시
        self.playlistCollectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                // 선택 해제된 셀의 인덱스를 ViewModel에 업데이트
                self.viewModel.selectedIndexPath.accept(nil)
            })
            .disposed(by: disposeBag)
        
        // 선택된 셀이 변경될 때마다 컬렉션 뷰 업데이트
        viewModel.selectedIndexPath
            .subscribe(onNext: { [weak self] selectedIndexPath in
                guard let self = self else { return }
                
                self.playlistCollectionView.visibleCells.forEach { cell in
                    guard let indexPath = self.playlistCollectionView.indexPath(for: cell) else { return }
                    let isSelected = (indexPath == selectedIndexPath)
                    
                    // 선택 상태에 따라 셀 업데이트
                    if let customCell = cell as? SelectPlaylistCollectionViewCell {
                        customCell.updateSelectionState(isSelected: isSelected)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setData() {
        playlistCollectionView.delegate = nil
        
        self.playlistCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.viewModel.playlistItem
            .observe(on: MainScheduler.instance)
            .bind(to: self.playlistCollectionView.rx.items(cellIdentifier: SelectPlaylistCollectionViewCell.identifier, cellType: SelectPlaylistCollectionViewCell.self)) { index, item, cell in
                cell.prepare(playlist: item, platform: self.sourcePlatform)
            }
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
        self.playlistCollectionView.rx.modelSelected(Playlist.self)
            .subscribe(onNext: { [weak self] playlistItem in
                playlistItem.id
            })
            .disposed(by: disposeBag)
        
        /*
        self.playlistCollectionView.rx.itemSelected
            .subscribe { [weak self] indexPath in
                guard let cell  = self?.playlistCollectionView.cellForItem(at: indexPath) as? TransferPlaylistCollectionViewCell else { return }
                self?.selectedPlaylistIndex = Observable.just(indexPath.row)
                cell.selected(selectedIndex: indexPath.row)
            }
            .disposed(by: disposeBag)
        
        self.selectedPlaylistIndex
            .subscribe(onNext: { index in
                guard let cell  = self.playlistCollectionView.cellForItem(at: IndexPath(index: index)) as? TransferPlaylistCollectionViewCell else { return }
                cell.selected(selectedIndex: index)
            })
            .disposed(by: disposeBag)
        */
    }
    
    private func setPlaylistAPI() {
        if sourcePlatform == .AppleMusic {
            Task {
                await self.setApplePlaylistAPI()
            }
        } else if sourcePlatform == .Spotify {
            setSpotifyPlaylistAPI()
        }
    }
    
    private func setSpotifyPlaylistAPI() {
        let url = EndPoint.playlistSpotifyRead.path
        let params = ["accessToken" : TokenManager.shared.spotifyAccessToken]
        
        APIService().post(of: [Playlist].self, url: url, parameters: params) { response in
            self.viewModel.playlistItem = Observable.just(response)
            self.setData()
        }
    }
    
    private func setApplePlaylistAPI() async {
        /*
         deprecated
         
         let controller = SKCloudServiceController()
         controller.requestUserToken(forDeveloperToken: "") { userToken, error in
         print("music user token : \(String(describing: userToken))")
         }
         */
        
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let userToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            
            let url = EndPoint.playlistAppleRead.path
            let params = ["musicUserToken" : userToken]
            
            APIService().post(of: [Playlist].self, url: url, parameters: params) { response in
                self.viewModel.playlistItem = Observable.just(response)
                self.setData()
            }
        } catch {
            print("ERROR : setApplePlaylistAPI")
        }
    }
}

@available(iOS 14.0, *)
extension SelectPlaylistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
        return CGSize(width: value, height: value / 140 * 190)
    }
}
