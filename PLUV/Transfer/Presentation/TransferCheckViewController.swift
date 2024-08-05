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

class TransferCheckViewController: UIViewController {
    
    var sourcePlatform: MusicPlatform = .AppleMusic
    var destinationPlatform: MusicPlatform = .Spotify
    
    private let destinationTitleView = UIView()
    private let destinationTitleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
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
        
        self.view.addSubview(destinationTitleView)
        destinationTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(124)
        }
        
        self.destinationTitleView.addSubview(destinationTitleLabel)
        destinationTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(28)
        }
        
        if destinationPlatform == .Spotify {
            destinationTitleLabel.text = "\(destinationPlatform.name)로\n플레이리스트를 옮길까요?"
        } else {
            destinationTitleLabel.text = "\(destinationPlatform.name)으로\n플레이리스트를 옮길까요?"
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
        let loadingView = LoadingView(loadingState: .LoadPlaylist)
        self.view.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
