//
//  HomeViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/9/24.
//

import UIKit
import StoreKit
import SnapKit
import Then
import MusicKit

class HomeViewController: UIViewController {
    
    private var destinationAccessToken = ""
    private let transferDirectButton = UIButton().then {
        $0.titleLabel?.text = "직접 옮기기"
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .systemGray
    }
    
    var musicList: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTestAppleMusic()
        Task {
            await self.setApplePlaylistAPI()
            await self.setApplePlaylistMusicAPI()
        }
    }
}

extension HomeViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        //self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(transferDirectButton)
        transferDirectButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        transferDirectButton.addTarget(self, action: #selector(clickTransferDirectButton), for: .touchUpInside)
    }
    
    @objc private func clickTransferDirectButton() {
        let transferSourceViewController = TransferSourceViewController()
        self.navigationController?.pushViewController(transferSourceViewController, animated: true)
    }
    
    private func setTestAppleMusic() {
        // MusicKitManager.shared.fetchMusic("알레프")
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
            print(developerToken, "developer token\n")
            print(userToken, "apple music user token")
            
            let url = EndPoint.playlistAppleRead.path
            let params = ["musicUserToken" : userToken]
            
            APIService().post(of: [Playlist].self, url: url, parameters: params) { response in
                print(response, "apple music playlist 확인")
            }
        } catch {
            print("error")
        }
    }
    
    private func setApplePlaylistMusicAPI() async {
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let userToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            print(userToken, "apple music user token")
            
            self.destinationAccessToken = userToken
            
            let url = EndPoint.playlistAppleMusicRead("p.YJXV7dEIekpNVAQ").path
            let params = ["musicUserToken" : userToken]
            
            APIService().post(of: APIResponse<[Music]>.self, url: url, parameters: params) { response in
                switch response.code {
                case 200:
                    self.musicList = response.data
                    print(params, "setApplePlaylistMusicAPI params 확인")
                    print(response.data, "song 확인")
//                    Task {
//                        await self.searchAppleToSpotifyAPI(musics: response.data)
//                    }
                    //self.addAppleToSpotify()
                default:
                    AlertController(message: response.msg).show()
                }
            }
        } catch {
            print("error")
        }
    }
    
    private func searchAppleToSpotifyAPI(musics: [Music]) async {
        do {
            let developerToken = try await DefaultMusicTokenProvider.init().developerToken(options: .ignoreCache)
            let userToken = try await MusicUserTokenProvider.init().userToken(for: developerToken, options: .ignoreCache)
            
            let jsonData = try JSONEncoder().encode(musics)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            let musicParams = jsonString.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "{", with: "[").replacingOccurrences(of: "}", with: "]").replacingOccurrences(of: "artistNames", with: "artistName")
            
            print(musicParams, "musicParams")
            
            let url = EndPoint.musicSpotifySearch.path
            let params = ["destinationAccessToken" : userToken,
                          "musics" : [
                            [
                                "title": "좋은 날",
                                "artistName": "아이유",
                                "isrcCode": "KRA381001057",
                                "imageUrl": "imageUrl"
                            ],
                            [
                                "title": "SPOT!",
                                "artistName": "지코,제니",
                                "isrcCode": "",
                                "imageUrl": "imageUrl"
                            ],
                            [
                                "title": "세상에 존재하지 않는 음악",
                                "artistName": "세상에 존재하지 않는 가수",
                                "isrcCode": "",
                                "imageUrl": "imageUrl"
                            ]
                          ]] as [String : Any]
            
            APIService().post(of: APIResponse<Search>.self, url: url, parameters: params) { response in
                switch response.code {
                case 200:
                    print(response.data, "searchAppleToSpotifyAPI")
                default:
                    AlertController(message: response.msg).show()
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func addAppleToSpotify() {
        let url = EndPoint.musicSpotifyAdd.path
        let params = [
                        "playListName": "추가할 playlistName",
                        "destinationAccessToken": destinationAccessToken,
                        "musicIds": [
                          "124nkd3fh",
                          "uo890df1"
                        ],
                        "transferFailMusics": [
                          [
                            "title": "조회되지 못한 음악",
                            "artistName": "조회되지 못한 아티스트",
                            "imageUrl": "imageUrl"
                          ],
                          [
                            "title": "유사하지만 선택하지 않은 음악",
                            "artistName": "아티스트",
                            "imageUrl": "imageUrl"
                          ]
                        ],
                        "thumbNailUrl": "thumbNailUrl",
                        "source": "spotify"
        ] as [String : Any]
        
        APIService().post(of: APIResponse<String>.self, url: url, parameters: params) { response in
            switch response.code {
            case 200:
                print(response.data, "addAppleToSpotify")
            default:
                print("here")
                AlertController(message: response.msg).show()
            }
        }
    }
}
