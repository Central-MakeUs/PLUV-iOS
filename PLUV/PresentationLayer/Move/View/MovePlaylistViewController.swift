//
//  MovePlaylistViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/18/24.
//

import UIKit
import MusicKit
import MediaPlayer

class MovePlaylistViewController: UIViewController {
    
    var viewModel = MovePlaylistViewModel()
    var meViewModel = MoveMeViewModel()
    var saveViewModel = MoveSaveViewModel()
    
    private var completeArr: [String] = []
    private var sourcePlatform: PlatformRepresentable?
    private var destinationPlatform: MusicPlatform = .Spotify
    private let stopView = ActionBottomView(actionName: "작업 중단하기")
    
    private let circleLoadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.mainPurple], lineWidth: 6)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    private var circleBackgroundView = UIView().then {
        $0.backgroundColor = .loadingBackgroundPurple
        $0.layer.cornerRadius = 150
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 150
        $0.layer.masksToBounds = false
    }
    private let innerCircleView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 144
        $0.clipsToBounds = true
    }
    private let centerContentView = UIView()
    private var sourceImageView = UIImageView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let dotImageView = UIImageView().then {
        $0.image = UIImage(named: "movedot_image")
    }
    private var destinationImageView = UIImageView().then {
        $0.image = UIImage(named: MusicPlatform.AppleMusic.iconSelect)
    }
    
    private let playlistTitleView = UIView()
    private let menuImageView = UIImageView().then {
        $0.image = UIImage(named: "menu_image")
    }
    private var playlistTitleLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18)
    }
    private var platformLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    private let xButton = UIButton().then {
        $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
    }
    
    init(musicArr: [String], source: PlatformRepresentable, destination: MusicPlatform) {
        super.init(nibName: nil, bundle: nil)
        self.completeArr = musicArr
        self.sourcePlatform = source
        self.destinationPlatform = destination
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setPlaylistData()
        setAddPlayList()
        
        circleLoadingIndicator.isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .never) {
            self.circleLoadingIndicator.isAnimating = false
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "플레이리스트 옮기기"
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.view.addSubview(circleBackgroundView)
        circleBackgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        self.view.addSubview(innerCircleView)
        innerCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(288)
        }
        
        self.view.addSubview(circleLoadingIndicator)
        circleLoadingIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(295)
        }
        
        /// center content view
        self.centerContentView.addSubview(sourceImageView)
        sourceImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(52)
            make.centerX.equalToSuperview()
        }
        
        self.centerContentView.addSubview(dotImageView)
        dotImageView.snp.makeConstraints { make in
            make.top.equalTo(sourceImageView.snp.bottom).offset(12)
            make.width.equalTo(6)
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
        }
        
        self.centerContentView.addSubview(destinationImageView)
        destinationImageView.snp.makeConstraints { make in
            make.top.equalTo(dotImageView.snp.bottom).offset(12)
            make.width.height.equalTo(97)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(centerContentView)
        centerContentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(stopView)
        stopView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        self.view.addSubview(platformLabel)
        platformLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(stopView.snp.top).offset(-20)
            make.height.equalTo(14)
        }
        
        self.playlistTitleView.addSubview(playlistTitleLabel)
        playlistTitleLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        
        self.playlistTitleView.addSubview(menuImageView)
        menuImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(playlistTitleLabel.snp.leading).offset(-4)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(playlistTitleView)
        playlistTitleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.bottom.equalTo(platformLabel.snp.top).offset(-8)
        }
        /*
         self.view.addSubview(xButton)
         xButton.snp.makeConstraints { make in
         make.width.height.equalTo(32)
         make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-5)
         make.trailing.equalToSuperview().inset(16)
         }
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickXButton))
         xButton.addGestureRecognizer(tapGesture)
         xButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
         
         // UIBarButtonItem 생성
         let rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(clickXButton))
         // 네비게이션 바의 오른쪽 아이템에 추가
         self.navigationItem.rightBarButtonItem = rightBarButtonItem
         */
        
        setXButton()
    }
    
    private func setAddPlayList() {
        if destinationPlatform == .AppleMusic {
            Task {
                await self.addToApple(musicIdsArr: completeArr)
            }
        } else {
            addToSpotify(musicIdsArr: completeArr)
        }
    }
    
    private func setPlaylistData() {
        if let musicPlatform = sourcePlatform as? LoadPluv, musicPlatform == .FromRecent {
            let thumbnailURL = URL(string: self.meViewModel.meItem?.imageURL ?? "")
            sourceImageView.kf.setImage(with: thumbnailURL)
            destinationImageView.image = UIImage(named: destinationPlatform.iconSelect)
            playlistTitleLabel.text = self.meViewModel.meItem?.title
            platformLabel.text = sourcePlatform!.name + " > " + destinationPlatform.name
        } else {
            let thumbnailURL = URL(string: self.saveViewModel.saveItem?.thumbNailURL ?? "")
            sourceImageView.kf.setImage(with: thumbnailURL)
            destinationImageView.image = UIImage(named: destinationPlatform.iconSelect)
            playlistTitleLabel.text = self.saveViewModel.saveItem?.title
            platformLabel.text = sourcePlatform!.name + " > " + destinationPlatform.name
        }
    }
    
    private func setXButton() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clickXButton))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func clickXButton() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count > 6 {
                let previousViewController = viewControllers[viewControllers.count - 7]
                navigationController.popToViewController(previousViewController, animated: true)
            } else {
                let previousViewController = viewControllers[viewControllers.count - 5]
                navigationController.popToViewController(previousViewController, animated: true)
            }
        }
    }
    
    ///  애플에 있는 것 스포티파이에 등록
    private func addToSpotify(musicIdsArr: [String]) {
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        
        print(loginToken, "UserDefaults 로그인 토큰 확인\n")
        print(TokenManager.shared.spotifyAccessToken, "스포티파이 토큰")
        
        let url = EndPoint.musicSpotifyAdd.path
        
        var params: [String: Any] = [:]
        
        if let musicPlatform = sourcePlatform as? LoadPluv, musicPlatform == .FromRecent {
            params = [
                "playListName": self.meViewModel.meItem?.title ?? "",
                "destinationAccessToken": TokenManager.shared.spotifyAccessToken,
                "musicIds": musicIdsArr,
                "transferFailMusics": [
                ],
                "thumbNailUrl": self.meViewModel.meItem?.imageURL ?? "",
                "source": "apple"
            ] as [String : Any]
        } else {
            params = [
                "playListName": self.saveViewModel.saveItem?.title ?? "",
                "destinationAccessToken": TokenManager.shared.spotifyAccessToken,
                "musicIds": musicIdsArr,
                "transferFailMusics": [
                ],
                "thumbNailUrl": self.saveViewModel.saveItem?.thumbNailURL ?? "",
                "source": "apple"
            ] as [String : Any]
        }
        
        APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: params, AccessToken: loginToken) { response in
            switch response.code {
            case 201:
                print(response.data, "addToSpotify")
                self.circleLoadingIndicator.isAnimating = false
                AlertController(message: "플레이리스트를 옮겼어요", completion: {
                    self.clickXButton()
                }).show()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
    
    /// 스포티파이에서 애플로 등록
    private func addToApple(musicIdsArr: [String]) async {
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let musicUserToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            
            let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
            
            let url = EndPoint.musicAppleAdd.path
            
            var params: [String: Any] = [:]
            
            if let musicPlatform = sourcePlatform as? LoadPluv, musicPlatform == .FromRecent {
                params = [
                    "playListName": self.meViewModel.meItem?.title ?? "",
                    "destinationAccessToken": musicUserToken,
                    "musicIds": musicIdsArr,
                    "transferFailMusics": [
                    ],
                    "thumbNailUrl": self.meViewModel.meItem?.imageURL ?? "",
                    "source": "spotify"
                ] as [String : Any]
            } else {
                params = [
                    "playListName": self.saveViewModel.saveItem?.title ?? "",
                    "destinationAccessToken": musicUserToken,
                    "musicIds": musicIdsArr,
                    "transferFailMusics": [
                    ],
                    "thumbNailUrl": self.saveViewModel.saveItem?.thumbNailURL ?? "",
                    "source": "spotify"
                ] as [String : Any]
            }
                
            APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: params, AccessToken: loginToken) { response in
                switch response.code {
                case 201:
                    print(response.data, "addToApple")
                    self.circleLoadingIndicator.isAnimating = false
                    AlertController(message: "플레이리스트를 옮겼어요", completion: {
                        self.clickXButton()
                    }).show()
                default:
                    AlertController(message: response.msg).show()
                }
            }
        } catch {
            print("ERROR : addSpotifyToApple")
        }
    }
}
