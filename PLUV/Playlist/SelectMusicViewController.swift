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

class SelectMusicViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let selectMusicTitleView = UIView()
    private let sourceToDestinationLabel = UILabel().then {
        $0.text = "스포티파이 > 애플뮤직"
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
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        $0.layer.borderWidth = 0.5
        
        $0.backgroundColor = .systemPink
    }
    private let sourcePlatformLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14)
        $0.text = "스포티파이"
    }
    private let playlistMenuImageView = UIImageView().then {
        $0.image = UIImage(named: "menu_image")
    }
    private let playlistNameLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.text = "여유로운 오후의 취향저격 팝"
    }
    private let playlistSongCountLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = .systemFont(ofSize: 14)
        $0.text = "총 10곡"
    }
    
    private let selectSongView = UIView()
    private let songCountLabel = UILabel().then {
        $0.textColor = .gray700
        $0.font = .systemFont(ofSize: 14)
        $0.text = "10곡"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setData()
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
        
        contentView.backgroundColor = .green
        
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
            make.width.equalTo(10)
            make.height.equalTo(6)
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
        
        moveView.trasferButton.isEnabled = false
        
        moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
    }
    
    @objc private func clickTransferButton() {
        
    }
    
    private func setData() {
        self.selectMusicTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.selectMusicTableView.rx.setDataSource(self)
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 스타일 제거
        self.selectMusicTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectMusicTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SelectMusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectMusicTableView.dequeueReusableCell(withIdentifier: SelectMusicTableViewCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
