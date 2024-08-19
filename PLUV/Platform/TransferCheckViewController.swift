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
    
    var sourcePlatform: MusicPlatform = .AppleMusic
    var destinationPlatform: MusicPlatform = .Spotify
    
    private let checkTitleView = UIView()
    private let checkTitleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    private lazy var selectSourcePlatformView = PlatformView(platform: sourcePlatform)
    private let dotView = DotView()
    private lazy var selectDestinationPlatformView = PlatformView(platform: destinationPlatform)
    
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
    
    // MARK: - 앱 생명 주기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(sourcePlatform.name)
        print(destinationPlatform.name)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(checkTitleView)
        checkTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(124)
        }
        
        self.checkTitleView.addSubview(checkTitleLabel)
        checkTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(28)
        }
        
        if destinationPlatform == .Spotify {
            checkTitleLabel.text = "\(destinationPlatform.name)로\n플레이리스트를 옮길까요?"
        } else {
            checkTitleLabel.text = "\(destinationPlatform.name)으로\n플레이리스트를 옮길까요?"
        }
        
        self.view.addSubview(selectSourcePlatformView)
        selectSourcePlatformView.snp.makeConstraints { make in
            make.top.equalTo(checkTitleView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(109)
        }
        
        self.view.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.top.equalTo(selectSourcePlatformView.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.height.equalTo(42)
            make.width.equalTo(6)
        }
        
        self.view.addSubview(selectDestinationPlatformView)
        selectDestinationPlatformView.snp.makeConstraints { make in
            make.top.equalTo(dotView.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.height.equalTo(109)
        }
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
    }
    
    @objc private func clickTransferButton() {
        if sourcePlatform == .AppleMusic {
            
        } else if sourcePlatform == .Spotify {
            connectSpotifySession()
        }
        
        let selectPlaylistVC = SelectPlaylistViewController(source: sourcePlatform, destination: destinationPlatform)
        self.navigationController?.pushViewController(selectPlaylistVC, animated: true)
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
