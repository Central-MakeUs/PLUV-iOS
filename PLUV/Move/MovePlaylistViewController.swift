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
    
    let viewModel = MovePlaylistViewModel()
    
    private var sourcePlatform: MusicPlatform = .AppleMusic
    private var destinationPlatform: MusicPlatform = .Spotify
    
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
        $0.textColor = .subBlue
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    private let xButton = UIButton().then {
        $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
    }
    
    private let stopView = ActionBottomView(actionName: "작업 중단하기")
    
    init(playlistItem: Playlist, musicItems: [Music], source: MusicPlatform, destination: MusicPlatform) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.playlistItem = playlistItem
        self.viewModel.musicItems = musicItems
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
        searchAPI()
        
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
    
    private func setPlaylistData() {
        let thumbnailURL = URL(string: self.viewModel.playlistItem.thumbnailURL)
        sourceImageView.kf.setImage(with: thumbnailURL)
        destinationImageView.image = UIImage(named: destinationPlatform.iconSelect)
        playlistTitleLabel.text = self.viewModel.playlistItem.name
        platformLabel.text = sourcePlatform.name + " > " + destinationPlatform.name
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
            }
        }
    }
    
    private func searchAPI() {
        if sourcePlatform == .AppleMusic && destinationPlatform == .Spotify {
            Task {
                await self.searchAppleToSpotifyAPI(musics: self.viewModel.musicItems)
            }
        } else if sourcePlatform == .Spotify && destinationPlatform == .AppleMusic {
            MPMediaLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    /// 권한이 부여된 경우
                    print("Apple Music authorization granted")
                    Task {
                        await self.searchSpotifyToAppleAPI(musics: self.viewModel.musicItems)
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
    }
    
    /// 애플에 있는 것 스포티파이에서 검색
    private func searchAppleToSpotifyAPI(musics: [Music]) async {
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
                                var idArr: [String] = []
                                let searchArr: [Search] = response.data
                                for search in searchArr {
                                    if search.isEqual == true {
                                        idArr.append(search.destinationMusics.first!.id!)
                                    } else {
                                        idArr.append(search.destinationMusics.first!.id!)
                                    }
                                }
                                print(response.data, "애플에 있는 것 스포티파이에서 검색")
                                self.addAppleToSpotify(musicIdsArr: idArr)
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
    
    /// 스포티파이에 있는 것 애플에서 검색
    private func searchSpotifyToAppleAPI(musics: [Music]) async {
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
                        print(params, "파람 확인")
                        APIService().post(of: APIResponse<[Search]>.self, url: url, parameters: params) { response in
                            switch response.code {
                            case 200:
                                var idArr: [String] = []
                                let searchArr: [Search] = response.data
                                for search in searchArr {
                                    if search.isEqual == true {
                                        idArr.append(search.destinationMusics.first!.id!)
                                    } else {
                                        if let id = search.destinationMusics.first?.id {
                                            idArr.append(id)
                                        }
                                    }
                                }
                                print(response.data, "스포티파이에 있는 것 애플에서 검색")
                                Task {
                                    await self.addSpotifyToApple(musicIdsArr: idArr)
                                }
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
    
    ///  애플에 있는 것 스포티파이에 등록
    private func addAppleToSpotify(musicIdsArr: [String]) {
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        
        print(loginToken, "UserDefaults 로그인 토큰 확인\n")
        print(TokenManager.shared.spotifyAccessToken, "스포티파이 토큰")
        
        let url = EndPoint.musicSpotifyAdd.path
        let params = [
                        "playListName": self.viewModel.playlistItem.name,
                        "destinationAccessToken": TokenManager.shared.spotifyAccessToken,
                        "musicIds": musicIdsArr,
                        "transferFailMusics": [
                        ],
                        "thumbNailUrl": self.viewModel.playlistItem.thumbnailURL,
                        "source": "apple"
        ] as [String : Any]
        
        APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: params, AccessToken: loginToken) { response in
            switch response.code {
            case 201:
                print(response.data, "addAppleToSpotify")
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
    private func addSpotifyToApple(musicIdsArr: [String]) async {
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let musicUserToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            
            let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
            
            let url = EndPoint.musicAppleAdd.path
            let params = [
                            "playListName": self.viewModel.playlistItem.name,
                            "destinationAccessToken": musicUserToken,
                            "musicIds": musicIdsArr,
                            "transferFailMusics": [
                            ],
                            "thumbNailUrl": self.viewModel.playlistItem.thumbnailURL,
                            "source": "spotify"
            ] as [String : Any]
            
            APIService().postWithAccessToken(of: APIResponse<String>.self, url: url, parameters: params, AccessToken: loginToken) { response in
                switch response.code {
                case 201:
                    print(response.data, "addSpotifyToApple")
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
