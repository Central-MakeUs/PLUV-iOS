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
import MediaPlayer
import MusicKit

class SelectMusicViewController: UIViewController {
    
    var completeArr: [String] = []
    var newViewModel = NewViewModel()
    var failArr = BehaviorRelay<[SearchMusic]>(value: [])
    var searchArr: [Search] = []
    
    var viewModel = SelectMusicViewModel()
    var meViewModel = SelectMeViewModel()
    var saveViewModel = SelectSaveViewModel()
    
    let loadingView = LoadingView(loadingState: .LoadMusic)
    let searchLoadingView = LoadingView(loadingState: .SearchMusic)
    
    var sourcePlatform: PlatformRepresentable?
    var destinationPlatform: MusicPlatform = .Spotify
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let selectMusicTitleView = UIView()
    private let sourceToDestinationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .gray800
    }
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
    }
    private let progressView = CustomProgressView()
    private let playlistTitleLabel = UILabel().then {
        $0.text = "플레이리스트의 음악이\n일치하는지 확인해주세요"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .gray800
    }
    private let playlistView = UIView()
    private let playlistThumnailImageView = UIImageView().then {
        $0.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        $0.layer.cornerRadius = 8
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
    private let backgroundLabel = UILabel().then {
        $0.backgroundColor = .gray200
    }
    
    private let selectMusicTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(SelectMusicTableViewCell.self, forCellReuseIdentifier: SelectMusicTableViewCell.identifier)
    }
    
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setMusicListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(selectMusicTitleView)
        selectMusicTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(221)
        }
        
        self.selectMusicTitleView.addSubview(sourceToDestinationLabel)
        sourceToDestinationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(46)
        }
        
        self.selectMusicTitleView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(53)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(34)
            make.width.equalTo(34)
        }
        backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
        
        self.selectMusicTitleView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(6)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(4)
        }
        progressView.updateProgress(to: 0.625)
        
        self.selectMusicTitleView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(68)
        }
        
        self.view.addSubview(playlistView)
        playlistView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(selectMusicTitleView.snp.bottom)
            make.height.equalTo(110)
        }
        
        self.playlistView.addSubview(playlistThumnailImageView)
        playlistThumnailImageView.snp.makeConstraints { make in
            make.width.height.equalTo(86)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        self.playlistView.addSubview(playlistMenuImageView)
        playlistMenuImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(playlistThumnailImageView.snp.trailing).offset(12)
            make.width.height.equalTo(20)
        }
        
        self.playlistView.addSubview(playlistNameLabel)
        playlistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playlistMenuImageView.snp.trailing).offset(4)
            make.centerY.equalTo(playlistMenuImageView)
            make.trailing.equalToSuperview().inset(24)
        }
        
        self.playlistView.addSubview(sourcePlatformLabel)
        sourcePlatformLabel.snp.makeConstraints { make in
            make.top.equalTo(playlistNameLabel.snp.bottom).offset(12)
            make.leading.equalTo(playlistThumnailImageView.snp.trailing).offset(12)
            make.height.equalTo(14)
        }
        
        self.playlistView.addSubview(playlistSongCountLabel)
        playlistSongCountLabel.snp.makeConstraints { make in
            make.top.equalTo(playlistNameLabel.snp.bottom).offset(12)
            make.leading.equalTo(sourcePlatformLabel.snp.trailing).offset(4)
            make.height.equalTo(14)
        }
        
        self.view.addSubview(selectSongView)
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
        
        self.selectSongView.addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(1.2)
        }
        
        self.view.addSubview(selectMusicTableView)
        selectMusicTableView.snp.makeConstraints { make in
            make.top.equalTo(selectSongView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(660)
            make.bottom.equalTo(view).inset(101)
        }
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setButtons()
    }
    
    private func setButtons() {
        setSelectAllButton()
        bindtrasferButton()
    }
    
    private func setSearchView() {
        self.view.addSubview(searchLoadingView)
        searchLoadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setValidationView(title: String, image: String) {
        let validationView = ValidationView(title: title, image: image)
        
        self.view.addSubview(validationView)
        validationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            validationView.removeFromSuperview()
        }
    }
    
    private func setPlaylistData() {
        if let musicPlatform = sourcePlatform as? MusicPlatform, musicPlatform == .AppleMusic || musicPlatform == .Spotify {
            let thumbnailURL = URL(string: self.viewModel.playlistItem?.thumbnailURL ?? "")
            playlistThumnailImageView.kf.setImage(with: thumbnailURL)
            sourceToDestinationLabel.text = sourcePlatform!.name + " > " + destinationPlatform.name
            sourcePlatformLabel.text = sourcePlatform!.name
            playlistNameLabel.text = self.viewModel.playlistItem?.name
            self.viewModel.musicItemCount { count in
                self.playlistSongCountLabel.text = "총 \(count)곡"
                self.songCountLabel.text = "\(count)곡"
            }
        } else if let musicPlatform = sourcePlatform as? LoadPluv, musicPlatform == .FromRecent {
            let thumbnailURL = URL(string: self.meViewModel.meItem?.imageURL ?? "")
            playlistThumnailImageView.kf.setImage(with: thumbnailURL)
            sourceToDestinationLabel.text = sourcePlatform!.name + " > " + destinationPlatform.name
            sourcePlatformLabel.text = sourcePlatform!.name
            playlistNameLabel.text = self.meViewModel.meItem?.title
            self.meViewModel.musicItemCount { count in
                self.playlistSongCountLabel.text = "총 \(count)곡"
                self.songCountLabel.text = "\(count)곡"
            }
        } else {
            let thumbnailURL = URL(string: self.saveViewModel.saveItem?.thumbNailURL ?? "")
            playlistThumnailImageView.kf.setImage(with: thumbnailURL)
            sourceToDestinationLabel.text = sourcePlatform!.name + " > " + destinationPlatform.name
            sourcePlatformLabel.text = sourcePlatform!.name
            playlistNameLabel.text = self.saveViewModel.saveItem?.title
            self.saveViewModel.musicItemCount { count in
                self.playlistSongCountLabel.text = "총 \(count)곡"
                self.songCountLabel.text = "\(count)곡"
            }
        }
    }
    
    @objc private func clickXButton() {
        var moveStopView = MoveStopView(title: "지금 중단하면 진행 사항이 사라져요.", target: self, num: 6)
        if self.saveViewModel.saveItem != nil || self.meViewModel.meItem != nil {
            moveStopView = MoveStopView(title: "지금 중단하면 진행 사항이 사라져요.", target: self, num: 4)
        }
        
        self.view.addSubview(moveStopView)
        moveStopView.alpha = 0
        moveStopView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            moveStopView.alpha = 1
        }
    }
    
    private func setSelectAllButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickSelectAllButton))
        selectAllLabel.addGestureRecognizer(tapGesture)
        selectAllLabel.isUserInteractionEnabled = true
    }
    
    @objc private func clickSelectAllButton() {
        if let musicPlatform = sourcePlatform as? MusicPlatform, musicPlatform == .AppleMusic || musicPlatform == .Spotify {
            /// 모든 셀을 선택할지 해제할지 결정
            let allSelected = viewModel.selectedMusic.value.count == viewModel.musicItem.value.count
            
            if allSelected {
                /// 모두 선택 해제
                viewModel.selectedMusic.accept([])
            } else {
                /// 모두 선택
                viewModel.selectedMusic.accept(viewModel.musicItem.value)
            }
            self.selectMusicTableView.reloadData()
        } else if let musicPlatform = sourcePlatform as? LoadPluv, musicPlatform == .FromRecent {
            let allSelected = meViewModel.selectedMusic.value.count == meViewModel.musicItem.value.count
            
            if allSelected {
                /// 모두 선택 해제
                meViewModel.selectedMusic.accept([])
            } else {
                /// 모두 선택
                meViewModel.selectedMusic.accept(meViewModel.musicItem.value)
            }
            self.selectMusicTableView.reloadData()
        } else {
            let allSelected = saveViewModel.selectedMusic.value.count == saveViewModel.musicItem.value.count
            
            if allSelected {
                /// 모두 선택 해제
                saveViewModel.selectedMusic.accept([])
            } else {
                /// 모두 선택
                saveViewModel.selectedMusic.accept(saveViewModel.musicItem.value)
            }
            self.selectMusicTableView.reloadData()
        }
    }
    
    private func bindtrasferButton() {
        moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
        
        if let musicPlatform = sourcePlatform as? MusicPlatform, musicPlatform == .AppleMusic || musicPlatform == .Spotify {
            /// selectedMusic의 변화를 관찰하여 trasferButton의 활성화 상태를 업데이트
            self.viewModel.selectedMusic
                .map { !$0.isEmpty } /// 선택된 음악이 있으면 true, 없으면 false
                .bind(to: moveView.trasferButton.rx.isEnabled)
                .disposed(by: disposeBag)
        } else if let musicPlatform = sourcePlatform as? LoadPluv, musicPlatform == .FromRecent {
            self.meViewModel.selectedMusic
                .map { !$0.isEmpty } /// 선택된 음악이 있으면 true, 없으면 false
                .bind(to: moveView.trasferButton.rx.isEnabled)
                .disposed(by: disposeBag)
        } else {
            self.saveViewModel.selectedMusic
                .map { !$0.isEmpty } /// 선택된 음악이 있으면 true, 없으면 false
                .bind(to: moveView.trasferButton.rx.isEnabled)
                .disposed(by: disposeBag)
        }
    }
    
    private func goNextStep() {
        if self.searchArr.count == self.completeArr.count {
            self.setValidationView(title: "플레이리스트의 모든 음악을 찾았어요!", image: "ok_image")
            /// 유효성 검사뷰 2초뒤 사라진 후 화면 넘어감
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let movePlaylistVC = MovePlaylistViewController(musicArr: self.completeArr, source: self.sourcePlatform!, destination: self.destinationPlatform)
                movePlaylistVC.viewModel.playlistItem = self.viewModel.playlistItem
                movePlaylistVC.meViewModel.meItem = self.meViewModel.meItem
                movePlaylistVC.saveViewModel.saveItem = self.saveViewModel.saveItem
                self.navigationController?.pushViewController(movePlaylistVC, animated: true)
            }
        } else {
            self.setValidationView(title: "앗, 찾을 수 없는 곡이 몇 개 있네요!", image: "alert_image")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let validationSimilarVC = ValidationSimilarViewController(completeArr: self.completeArr, successSimilarArr: self.newViewModel, failArr: self.failArr, source: self.sourcePlatform!, destination: self.destinationPlatform)
                validationSimilarVC.viewModel.playlistItem = self.viewModel.playlistItem
                validationSimilarVC.meViewModel.meItem = self.meViewModel.meItem
                validationSimilarVC.saveViewModel.saveItem = self.saveViewModel.saveItem
                self.navigationController?.pushViewController(validationSimilarVC, animated: true)
            }
        }
    }
    
    @objc private func clickTransferButton() {
        guard let sourcePlatform = sourcePlatform else { return }
        
        let selectedMusicObservable: BehaviorRelay<[Music]>?
        let transferAPI: ([Music], @escaping () -> Void) async -> Void
        
        switch (sourcePlatform, destinationPlatform) {
        case (let platform as MusicPlatform, .Spotify) where platform == .AppleMusic:
            selectedMusicObservable = viewModel.selectedMusic
            transferAPI = searchToSpotifyAPI
        case (let platform as LoadPluv, .Spotify) where platform == .FromRecent:
            selectedMusicObservable = meViewModel.selectedMusic
            transferAPI = searchToSpotifyAPI
        case (let platform as LoadPluv, .Spotify) where platform == .FromSave:
            selectedMusicObservable = saveViewModel.selectedMusic
            transferAPI = searchToSpotifyAPI
        case (let platform as MusicPlatform, .AppleMusic) where platform == .Spotify:
            selectedMusicObservable = viewModel.selectedMusic
            transferAPI = searchToAppleAPI
        case (let platform as LoadPluv, .AppleMusic) where platform == .FromRecent:
            selectedMusicObservable = meViewModel.selectedMusic
            transferAPI = searchToAppleAPI
        case (let platform as LoadPluv, .AppleMusic) where platform == .FromSave:
            selectedMusicObservable = saveViewModel.selectedMusic
            transferAPI = searchToAppleAPI
        default:
            return
        }
        
        if destinationPlatform == .AppleMusic {
            selectedMusicObservable?
                .map { musicArray in
                    MPMediaLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized:
                            /// 권한이 부여된 경우
                            print("Apple Music authorization granted")
                            Task {
                                await transferAPI(musicArray) {
                                    DispatchQueue.main.async {
                                        self.goNextStep()
                                    }
                                }
                            }
                        default:
                            DispatchQueue.main.async {
                                AlertController(message: "미디어 권한을 허용해야 사용할 수 있어요") {
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }.show()
                            }
                        }
                    }
                }
                .subscribe { musicArray in
                    print(musicArray)
                }
                .disposed(by: disposeBag)
        } else {
            selectedMusicObservable?
                .map { musicArray in
                    Task {
                        await transferAPI(musicArray) {
                            DispatchQueue.main.async {
                                self.goNextStep()
                            }
                        }
                    }
                }
                .subscribe { musicArray in
                    print(musicArray)
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func configureTableView(for viewModel: SelectMusicViewModelProtocol) {
        self.selectMusicTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.selectMusicTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectMusicTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.selectedMusic.accept(viewModel.musicItem.value)

        viewModel.musicItem
            .observe(on: MainScheduler.instance)
            .bind(to: self.selectMusicTableView.rx.items(cellIdentifier: SelectMusicTableViewCell.identifier, cellType: SelectMusicTableViewCell.self)) { row, music, cell in
                cell.prepare(music: music)
                
                let isSelected = viewModel.selectedMusic.value.contains {
                    $0.title == music.title && $0.artistNames == music.artistNames
                }
                cell.updateSelectionUI(isSelected: isSelected)
            }
            .disposed(by: disposeBag)

        self.selectMusicTableView.rx.modelSelected(Music.self)
            .subscribe(onNext: { music in
                viewModel.musicSelect(music: music)
                self.selectMusicTableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.selectedMusic
            .subscribe(onNext: { [weak self] _ in
                self?.selectMusicTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func setData() {
        configureTableView(for: viewModel)
    }

    private func setMeData() {
        configureTableView(for: meViewModel)
    }

    private func setSaveData() {
        configureTableView(for: saveViewModel)
    }
    
    private func setMusicListAPI() {
        if let musicPlatform = sourcePlatform as? MusicPlatform, musicPlatform == .AppleMusic {
            Task {
                await self.setAppleMusicListAPI()
            }
        } else if let musicPlatform = sourcePlatform as? MusicPlatform, musicPlatform == .Spotify {
            setSpotifyMusicListAPI()
        } else if let musicPlatform = sourcePlatform as? LoadPluv, musicPlatform == .FromRecent {
            setMeMusicListAPI()
        } else {
            setSaveMusicListAPI()
        }
    }
    
    private func setAppleMusicListAPI() async {
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let userToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            
            let url = EndPoint.playlistAppleMusicRead(self.viewModel.playlistItem?.id ?? "").path
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
        let url = EndPoint.playlistMusicSpotifyRead(self.viewModel.playlistItem?.id ?? "").path
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
    
    private func setMeMusicListAPI() {
        let recentId = meViewModel.meItem?.id ?? 0
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        let url = EndPoint.historySuccess("\(recentId)").path
        
        APIService().getWithAccessToken(of: APIResponse<[Music]>.self, url: url, AccessToken: loginToken) { response in
            switch response.code {
            case 200:
                self.meViewModel.musicItem.accept(response.data)
                self.setMeData()
                self.setPlaylistData()
                self.loadingView.removeFromSuperview()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
    
    private func setSaveMusicListAPI() {
        let saveId = saveViewModel.saveItem?.id ?? 0
        let url = EndPoint.feedIdMusic("\(saveId)").path
        
        APIService().get(of: APIResponse<[Music]>.self, url: url) { response in
            switch response.code {
            case 200:
                self.saveViewModel.musicItem.accept(response.data)
                self.setSaveData()
                self.setPlaylistData()
                self.loadingView.removeFromSuperview()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
    
    private func searchToSpotifyAPI(musics: [Music], completion: @escaping () -> Void) async {
        self.setSearchView()
        do {
            let jsonData = try JSONEncoder().encode(musics)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let musicParams = jsonString.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "artistNames", with: "artistName")
            
            if let parameterJsonData = musicParams.data(using: .utf8) {
                do {
                    if let parameterJsonArray = try JSONSerialization.jsonObject(with: parameterJsonData, options: []) as? [[String: Any]] {
                        
                        let url = EndPoint.musicSpotifySearch.path
                        let params = ["destinationAccessToken" : TokenManager.shared.spotifyAccessToken,
                                      "musics" : parameterJsonArray] as [String : Any]
                        
                        APIService().post(of: APIResponse<[Search]>.self, url: url, parameters: params) { response in
                            switch response.code {
                            case 200:
                                self.searchArr = response.data
                                for i in 0..<self.searchArr.count {
                                    if self.searchArr[i].isEqual == true && self.searchArr[i].isFound == true {
                                        self.completeArr.append(self.searchArr[i].destinationMusics.first!.id!)
                                    } else if self.searchArr[i].isEqual == false && self.searchArr[i].isFound == true {
                                        self.newViewModel.successArr.append(self.searchArr[i].sourceMusic)
                                        self.newViewModel.musicItem.append(self.searchArr[i].destinationMusics[0])
                                    } else {
                                        self.failArr.append(self.searchArr[i].sourceMusic)
                                    }
                                }
                                self.searchLoadingView.removeFromSuperview()
                                completion()
                                print(response.data, "애플에 있는 것 스포티파이에서 검색")
                            default:
                                AlertController(message: response.msg).show()
                            }
                        }
                    }
                } catch {
                    print("JSON 변환 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func searchToAppleAPI(musics: [Music], completion: @escaping () -> Void) async {
        self.setSearchView()
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let userToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            
            let jsonData = try JSONEncoder().encode(musics)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let musicParams = jsonString.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "artistNames", with: "artistName")
            
            if let parameterJsonData = musicParams.data(using: .utf8) {
                do {
                    if let parameterJsonArray = try JSONSerialization.jsonObject(with: parameterJsonData, options: []) as? [[String: Any]] {
                        
                        let url = EndPoint.musicAppleSearch.path
                        let params = ["destinationAccessToken" : userToken,
                                      "musics" : parameterJsonArray] as [String : Any]
                        APIService().post(of: APIResponse<[Search]>.self, url: url, parameters: params) { response in
                            switch response.code {
                            case 200:
                                self.searchArr = response.data
                                for i in 0..<self.searchArr.count {
                                    if self.searchArr[i].isEqual == true && self.searchArr[i].isFound == true {
                                        self.completeArr.append(self.searchArr[i].destinationMusics.first!.id!)
                                        self.newViewModel.successArr.append(self.searchArr[i].sourceMusic)
                                        self.newViewModel.musicItem.append(self.searchArr[i].destinationMusics[0])
                                    } else if self.searchArr[i].isEqual == false && self.searchArr[i].isFound == true {
//                                        self.newViewModel.successArr.append(self.searchArr[i].sourceMusic)
//                                        self.newViewModel.musicItem.append(self.searchArr[i].destinationMusics[0])
                                    } else {
                                        self.failArr.append(self.searchArr[i].sourceMusic)
                                    }
                                }
                                self.searchLoadingView.removeFromSuperview()
                                completion()
                                print(response.data, "스포티파이에 있는 것 애플에서 검색")
                            default:
                                AlertController(message: response.msg).show()
                            }
                        }
                    }
                } catch {
                    print("JSON 변환 실패: \(error.localizedDescription)")
                }
            }
        } catch {
            print(error)
        }
    }
}

extension SelectMusicViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
}
