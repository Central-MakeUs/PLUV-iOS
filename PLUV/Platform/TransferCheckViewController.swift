//
//  TransferCheckViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SpotifyiOS

class TransferCheckViewController: UIViewController {
   
   var sourcePlatform: PlatformRepresentable?
   var destinationPlatform: PlatformRepresentable?
    
    var meViewModel = SelectMeViewModel()
    var saveViewModel = SelectSaveViewModel()
   
   private let checkTitleView = UIView()
   private let backButton = UIButton().then {
      $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
   }
   private let progressView = CustomProgressView()
   private let checkTitleLabel = UILabel().then {
      $0.numberOfLines = 0
      $0.font = .systemFont(ofSize: 24, weight: .semibold)
      $0.textColor = .gray800
   }
   
   private var selectSourcePlatformView: PlatformView?
   private let dotView = DotView()
    private var selectDestinationPlatformView: PlatformView?
   
   private var moveView = MoveView(view: UIViewController())
   private let disposeBag = DisposeBag()
   
   /// spotify 관련 properties
   // MARK: - Spotify Authorization & Configuration
   var responseCode: String? {
      didSet {
         fetchAccessToken { (dictionary, error) in
            if let error = error {
               print("Fetching token request error \(error)")
               return
            }
            let accessToken = dictionary!["access_token"] as! String
            DispatchQueue.main.async {
               self.appRemote.connectionParameters.accessToken = accessToken
               self.appRemote.connect()
            }
         }
      }
   }
   
   lazy var appRemote: SPTAppRemote = {
      let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
      appRemote.connectionParameters.accessToken = self.accessToken
      appRemote.delegate = self
      return appRemote
   }()
   
   var accessToken = UserDefaults.standard.string(forKey: spotifyAccessTokenKey) {
      didSet {
         let defaults = UserDefaults.standard
         defaults.set(accessToken, forKey: spotifyAccessTokenKey)
      }
   }
   
   lazy var configuration: SPTConfiguration = {
      let configuration = SPTConfiguration(clientID: spotifyClientId, redirectURL: redirectUri)
      // Set the playURI to a non-nil value so that Spotify plays music after authenticating
      // otherwise another app switch will be required
      configuration.playURI = ""
      // Set these url's to your backend which contains the secret to exchange for an access token
      // You can use the provided ruby script spotify_token_swap.rb for testing purposes
      configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
      configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
      return configuration
   }()
   
   lazy var sessionManager: SPTSessionManager? = {
      let manager = SPTSessionManager(configuration: configuration, delegate: self)
      return manager
   }()
   
   private var lastPlayerState: SPTAppRemotePlayerState?
   
   func update(playerState: SPTAppRemotePlayerState) {
      lastPlayerState = playerState
   }
   
   func connectSpotifySession() {
      guard let sessionManager = sessionManager else { return }
      sessionManager.initiateSession(with: scopes, options: .clientOnly, campaign: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUI()
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      self.view.addSubview(checkTitleView)
      checkTitleView.snp.makeConstraints { make in
         make.top.leading.trailing.equalToSuperview()
         make.height.equalTo(213)
      }
      
      self.checkTitleView.addSubview(backButton)
      backButton.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(53)
         make.trailing.equalToSuperview().inset(16)
         make.height.equalTo(34)
         make.width.equalTo(34)
      }
      backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
      
      self.checkTitleView.addSubview(progressView)
      progressView.snp.makeConstraints { make in
         make.top.equalTo(backButton.snp.bottom).offset(6)
         make.trailing.leading.equalToSuperview()
         make.height.equalTo(4)
      }
      progressView.updateProgress(to: 0.375)
      
      self.checkTitleView.addSubview(checkTitleLabel)
      checkTitleLabel.snp.makeConstraints { make in
         make.top.equalTo(progressView.snp.bottom).offset(24)
         make.leading.equalToSuperview().inset(24)
         make.height.equalTo(68)
      }
      
      if let musicPlatform = destinationPlatform as? MusicPlatform, musicPlatform == .Spotify {
          checkTitleLabel.text = "\(destinationPlatform!.name)로\n플레이리스트를 옮길까요?"
      } else {
          checkTitleLabel.text = "\(destinationPlatform!.name)으로\n플레이리스트를 옮길까요?"
      }
      
      let fullText = checkTitleLabel.text ?? ""
       let changeText = destinationPlatform!.name
      let attributedString = NSMutableAttributedString(string: fullText)
      
      if let range = fullText.range(of: changeText) {
         let nsRange = NSRange(range, in: fullText)
         attributedString.addAttribute(.foregroundColor, value: UIColor.mainPurple, range: nsRange)
      }
      
      checkTitleLabel.attributedText = attributedString
      
      if let platform = sourcePlatform {
         selectSourcePlatformView = PlatformView(platform: platform)
         if let platformView = selectSourcePlatformView {
            self.view.addSubview(platformView)
            platformView.snp.makeConstraints { make in
               make.top.equalTo(checkTitleView.snp.bottom).offset(4)
               make.centerX.equalToSuperview()
               make.height.equalTo(109)
            }
         }
      }
      
      self.view.addSubview(dotView)
      dotView.snp.makeConstraints { make in
         make.top.equalTo(selectSourcePlatformView!.snp.bottom).offset(23)
         make.centerX.equalToSuperview()
         make.height.equalTo(42)
         make.width.equalTo(6)
      }
      
       if let platform = destinationPlatform {
           selectDestinationPlatformView = PlatformView(platform: platform)
           if let platformView = selectDestinationPlatformView {
               self.view.addSubview(platformView)
               platformView.snp.makeConstraints { make in
                   make.top.equalTo(dotView.snp.bottom).offset(23)
                   make.centerX.equalToSuperview()
                   make.height.equalTo(109)
               }
           }
       }
      
      moveView = MoveView(view: self)
      self.view.addSubview(moveView)
      moveView.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.height.equalTo(101)
      }
      
      moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
   }
   
   @objc private func clickXButton() {
       var moveStopView = MoveStopView(title: "지금 중단하면 진행 사항이 사라져요.", target: self, num: 4)
       if self.saveViewModel.saveItem != nil || self.meViewModel.meItem != nil {
           moveStopView = MoveStopView(title: "지금 중단하면 진행 사항이 사라져요.", target: self, num: 2)
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
   
   @objc private func clickTransferButton() {
      if let musicPlatform = sourcePlatform as? MusicPlatform, musicPlatform == .AppleMusic {
         
      } else if let musicPlatform = sourcePlatform as? MusicPlatform, musicPlatform == .Spotify {
         connectSpotifySession()
      }
       
       if saveViewModel.saveItem != nil {
           let selectMusicVC = SelectMusicViewController()
           selectMusicVC.saveViewModel.saveItem = saveViewModel.saveItem
           selectMusicVC.sourcePlatform = sourcePlatform
           selectMusicVC.destinationPlatform = destinationPlatform as! MusicPlatform
           self.navigationController?.pushViewController(selectMusicVC, animated: true)
       } else if meViewModel.meItem != nil {
           let selectMusicVC = SelectMusicViewController()
           selectMusicVC.meViewModel.meItem = meViewModel.meItem
           selectMusicVC.sourcePlatform = sourcePlatform
           selectMusicVC.destinationPlatform = destinationPlatform as! MusicPlatform
           self.navigationController?.pushViewController(selectMusicVC, animated: true)
       } else {
           let selectPlaylistVC = SelectPlaylistViewController(source: sourcePlatform ?? MusicPlatform.AppleMusic, destination: destinationPlatform as! MusicPlatform)
          self.navigationController?.pushViewController(selectPlaylistVC, animated: true)
       }
   }
}

// MARK: - SPTAppRemoteDelegate
extension TransferCheckViewController: SPTAppRemoteDelegate {
   func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
      appRemote.playerAPI?.delegate = self
      appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
         if let error = error {
            print("Error subscribing to player state:" + error.localizedDescription)
         }
      })
      fetchPlayerState()
   }
   
   func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      lastPlayerState = nil
   }
   
   func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      lastPlayerState = nil
   }
}

// MARK: - SPTAppRemotePlayerAPIDelegate
extension TransferCheckViewController: SPTAppRemotePlayerStateDelegate {
   func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      debugPrint("Spotify Track name: %@", playerState.track.name)
      update(playerState: playerState)
   }
}

// MARK: - SPTSessionManagerDelegate
extension TransferCheckViewController: SPTSessionManagerDelegate {
   func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
      if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
         print("AUTHENTICATE with WEBAPI")
      }
   }
   
   func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
      print("Session Renewed", session.description)
   }
   
   func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
      appRemote.connectionParameters.accessToken = session.accessToken
      appRemote.connect()
   }
}

// MARK: - Networking
extension TransferCheckViewController {
   
   func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
      let url = URL(string: "https://accounts.spotify.com/api/token")!
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      let spotifyAuthKey = "Basic \((spotifyClientId + ":" + spotifyClientSecretKey).data(using: .utf8)!.base64EncodedString())"
      request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                     "Content-Type": "application/x-www-form-urlencoded"]
      
      var requestBodyComponents = URLComponents()
      let scopeAsString = stringScopes.joined(separator: " ")
      
      requestBodyComponents.queryItems = [
         URLQueryItem(name: "client_id", value: spotifyClientId),
         URLQueryItem(name: "grant_type", value: "authorization_code"),
         URLQueryItem(name: "code", value: responseCode!),
         URLQueryItem(name: "redirect_uri", value: redirectUri.absoluteString),
         URLQueryItem(name: "code_verifier", value: ""), // not currently used
         URLQueryItem(name: "scope", value: scopeAsString),
      ]
      
      request.httpBody = requestBodyComponents.query?.data(using: .utf8)
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
         guard let data = data,                              // is there data
               let response = response as? HTTPURLResponse,  // is there HTTP response
               (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
               error == nil else {                           // was there no error, otherwise ...
            print("Error fetching token \(error?.localizedDescription ?? "")")
            return completion(nil, error)
         }
         let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
         
         print("확인", responseObject ?? "")
         
         guard let dictionary = responseObject, let accessToken = dictionary["access_token"] as? String else {
            print("Failed to parse access token from response.")
            return completion(nil, nil)
         }
         
         print(accessToken, "check token")
         
         UserDefaults.standard.setValue(accessToken, forKey: spotifyAccessTokenKey)
         self.accessToken = accessToken
         
         completion(dictionary, nil)
      }
      task.resume()
   }
   
   func fetchPlayerState() {
      appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
         if let error = error {
            print("Error getting player state:" + error.localizedDescription)
         } else if let playerState = playerState as? SPTAppRemotePlayerState {
            self?.update(playerState: playerState)
         }
      })
   }
}
