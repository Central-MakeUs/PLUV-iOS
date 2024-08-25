//
//  SelectMusicViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MusicKit

class SelectMusicViewController: UIViewController {
    
    let viewModel = SelectMusicViewModel()
    
    let loadingView = LoadingView(loadingState: .LoadMusic)
    
    private var sourcePlatform: MusicPlatform = .AppleMusic
    private var destinationPlatform: MusicPlatform = .Spotify
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let selectMusicTitleView = UIView()
    private let sourceToDestinationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .subBlue
    }
    private let playlistTitleLabel = UILabel().then {
        $0.text = "플레이리스트의 음악이\n일치하는지 확인해주세요"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .gray800
    }
    
    private let playlistView = UIView()
    private let playlistThumnailImageView = UIImageView().then {
        // $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        $0.layer.borderWidth = 0.5
        $0.clipsToBounds = true
    }
    private let sourcePlatformLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14)
    }
    private let playlistMenuImageView = UIImageView().then {
        $0.image = UIImage(named: "menu_image")
    }
    private let playlistNameLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let playlistSongCountLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = .systemFont(ofSize: 14)
    }
    
    private let selectSongView = UIView()
    private let songCountLabel = UILabel().then {
        $0.textColor = .gray700
        $0.font = .systemFont(ofSize: 14)
    }
    private let selectAllLabel = UILabel().then {
        $0.textColor = .mainPurple //.gray800
        $0.font = .systemFont(ofSize: 14)
        $0.text = "전체선택"
    }
    private let checkImageView = UIImageView().then {
        $0.image = UIImage(named: "check_image")
    }
    
    private let selectMusicTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(SelectMusicTableViewCell.self, forCellReuseIdentifier: SelectMusicTableViewCell.identifier)
    }
    
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
    init(playlistItem: Playlist, source: MusicPlatform, destination: MusicPlatform) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.playlistItem = playlistItem
        self.sourcePlatform = source
        self.destinationPlatform = destination
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setMusicListAPI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        self.contentView.addSubview(selectMusicTitleView)
        selectMusicTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(146)
        }
        
        self.selectMusicTitleView.addSubview(sourceToDestinationLabel)
        sourceToDestinationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(14)
        }
        
        self.selectMusicTitleView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sourceToDestinationLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(28)
        }
        
        self.contentView.addSubview(playlistView)
        playlistView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(selectMusicTitleView.snp.bottom)
            make.height.equalTo(126)
        }
        
        self.playlistView.addSubview(playlistThumnailImageView)
        playlistThumnailImageView.snp.makeConstraints { make in
            make.width.height.equalTo(86)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        self.playlistView.addSubview(sourcePlatformLabel)
        sourcePlatformLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalTo(playlistThumnailImageView.snp.trailing).offset(12)
            make.height.equalTo(14)
            make.trailing.equalToSuperview().inset(24)
        }
        
        self.playlistView.addSubview(playlistMenuImageView)
        playlistMenuImageView.snp.makeConstraints { make in
            make.top.equalTo(sourcePlatformLabel.snp.bottom).offset(10)
            make.leading.equalTo(sourcePlatformLabel.snp.leading)
            make.width.height.equalTo(20)
        }
        
        self.playlistView.addSubview(playlistNameLabel)
        playlistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playlistMenuImageView.snp.trailing).offset(4)
            make.centerY.equalTo(playlistMenuImageView)
            make.trailing.equalToSuperview().inset(24)
        }
        
        self.playlistView.addSubview(playlistSongCountLabel)
        playlistSongCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(sourcePlatformLabel.snp.leading)
            make.bottom.equalTo(playlistThumnailImageView.snp.bottom).offset(-3)
            make.height.equalTo(14)
            make.trailing.equalToSuperview().inset(24)
        }
        
        self.contentView.addSubview(selectSongView)
        selectSongView.snp.makeConstraints { make in
            make.top.equalTo(playlistView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(38)
        }
        
        self.selectSongView.addSubview(songCountLabel)
        songCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.selectSongView.addSubview(selectAllLabel)
        selectAllLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
        
        self.selectSongView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.trailing.equalTo(selectAllLabel.snp.leading).offset(-6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        self.contentView.addSubview(selectMusicTableView)
        selectMusicTableView.snp.makeConstraints { make in
            make.top.equalTo(selectSongView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(660)
            make.bottom.equalTo(view).inset(101)
        }
        //selectMusicTableView.isScrollEnabled = false
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        // moveView.trasferButton.isEnabled = false
        moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
        
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setXButton()
    }
    
    private func setXButton() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clickXButton))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func clickXButton() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count > 5 {
                let previousViewController = viewControllers[viewControllers.count - 6]
                navigationController.popToViewController(previousViewController, animated: true)
            }
        }
    }
    
    @objc private func clickTransferButton() {
        self.viewModel.selectedMusic
            .map { musicArray in
                let movePlaylistVC = MovePlaylistViewController(playlistItem: self.viewModel.playlistItem, musicItems: musicArray, source: self.sourcePlatform, destination: self.destinationPlatform)
                self.navigationController?.pushViewController(movePlaylistVC, animated: true)
            }
            .subscribe { musicArray in
                print(musicArray)
            }
            .disposed(by: disposeBag)
    }
    
    private func setPlaylistData() {
        let thumbnailURL = URL(string: self.viewModel.playlistItem.thumbnailURL)
        playlistThumnailImageView.kf.setImage(with: thumbnailURL)
        sourceToDestinationLabel.text = sourcePlatform.name + " > " + destinationPlatform.name
        sourcePlatformLabel.text = sourcePlatform.name
        playlistNameLabel.text = self.viewModel.playlistItem.name
        self.viewModel.musicItemCount { count in
            self.playlistSongCountLabel.text = "총 \(count)곡"
            self.songCountLabel.text = "\(count)곡"
        }
    }
    
    private func setData() {
        self.selectMusicTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 스타일 제거
        self.selectMusicTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectMusicTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        /// 모든 cell 선택된 상태로 세팅
        self.viewModel.selectedMusic.accept(viewModel.musicItem.value)
        
        /// TableView에 들어갈 Cell에 정보 제공
        self.viewModel.musicItem
            .observe(on: MainScheduler.instance)
            .bind(to: self.selectMusicTableView.rx.items(cellIdentifier: SelectMusicTableViewCell.identifier, cellType: SelectMusicTableViewCell.self)) { row, music, cell in
                cell.prepare(music: music)
                
                /// 현재 음악이 선택된 상태인지 확인하고 UI 업데이트
                let isSelected = self.viewModel.selectedMusic.value.contains(where: { $0.title == music.title && $0.artistNames == music.artistNames })
                cell.updateSelectionUI(isSelected: isSelected)
            }
            .disposed(by: disposeBag)
        
        /// 셀 선택 처리
        self.selectMusicTableView.rx.modelSelected(Music.self)
            .subscribe(onNext: { [weak self] music in
                self?.viewModel.musicSelect(music: music)
                self?.selectMusicTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        /// 선택한 음악의 변화를 관찰하고 이에 따라 UI를 업데이트
        self.viewModel.selectedMusic
            .subscribe(onNext: { [weak self] selectedMusic in
                self?.selectMusicTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setMusicListAPI() {
        if sourcePlatform == .AppleMusic {
            Task {
                await self.setAppleMusicListAPI()
            }
        } else if sourcePlatform == .Spotify {
            setSpotifyMusicListAPI()
        }
    }
    
    private func setAppleMusicListAPI() async {
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let userToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            
            let url = EndPoint.playlistAppleMusicRead(self.viewModel.playlistItem.id).path
            let params = ["musicUserToken" : userToken]
            
            APIService().post(of: APIResponse<[Music]>.self, url: url, parameters: params) { response in
                switch response.code {
                case 200:
                    self.viewModel.musicItem.accept(response.data)
                    self.setData()
                    self.setPlaylistData()
                    self.loadingView.removeFromSuperview()
                    self.view.layoutIfNeeded()
                default:
                    AlertController(message: response.msg).show()
                }
            }
        } catch {
            print("ERROR : setAppleMusicListAPI")
        }
    }
    
    private func setSpotifyMusicListAPI() {
        let url = EndPoint.playlistMusicSpotifyRead(self.viewModel.playlistItem.id).path
        let params = ["accessToken" : TokenManager.shared.spotifyAccessToken]
        
        APIService().post(of: APIResponse<[Music]>.self, url: url, parameters: params) { response in
            switch response.code {
            case 200:
                self.viewModel.musicItem.accept(response.data)
                self.setData()
                self.setPlaylistData()
                self.loadingView.removeFromSuperview()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
}

extension SelectMusicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
