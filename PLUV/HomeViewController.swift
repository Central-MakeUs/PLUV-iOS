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
    
    private let transferDirectButton = UIButton().then {
        $0.titleLabel?.text = "직접 옮기기"
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.backgroundColor = .systemGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTestAppleMusic()
        Task {
            await self.setApplePlaylist()
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
    
    private func setApplePlaylist() async {
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
            
            APIService().post(of: [SpotifyPlaylist].self, url: url, parameters: params) { response in
                print(response, "apple music playlist 확인")
            }
        } catch {
            print("error")
        }
    }
}
