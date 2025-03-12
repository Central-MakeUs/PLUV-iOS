//
//  ValidationSimilarViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxRelay
import RxDataSources

class ValidationSimilarViewController: UIViewController {
    
    var viewModel = MovePlaylistViewModel()
    var meViewModel = MoveMeViewModel()
    var saveViewModel = MoveSaveViewModel()
    private var newViewModel = NewViewModel()
    private let disposeBag = DisposeBag()
    
    private var completeArr: [String] = []
    private var moveView = MoveView(view: UIViewController())
    private var failArr = BehaviorRelay<[SearchMusic]>(value: [])
    
    private var sourcePlatform: PlatformRepresentable?
    private var destinationPlatform: MusicPlatform = .Spotify
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let similarTitleView = UIView()
    private let sourceToDestinationLabel = UILabel().then {
        $0.text = "Spotify > AppleMusic"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .gray800
    }
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
    }
    private let progressView = CustomProgressView()
    private let similarTitleLabel1 = UILabel().then {
        $0.text = "가장 유사한 항목을 옮길까요?"
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .gray800
    }
    private let similarTitleLabel2 = UILabel().then {
        $0.text = "원곡과 일부 정보가 일치하는 음악이에요"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .gray600
    }
    private let similarSongView = UIView()
    private let songCountLabel = UILabel().then {
        $0.text = "3곡"
        $0.textColor = .gray700
        $0.font = .systemFont(ofSize: 14)
    }
    private let similarMusicTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(ValidationSimilarTableViewCell.self, forCellReuseIdentifier: ValidationSimilarTableViewCell.identifier)
        $0.register(SimilarSongsTableViewCell.self, forCellReuseIdentifier: SimilarSongsTableViewCell.identifier)
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    init(completeArr: [String], successSimilarArr: NewViewModel, failArr: BehaviorRelay<[SearchMusic]>, source: PlatformRepresentable, destination: MusicPlatform) {
        super.init(nibName: nil, bundle: nil)
        self.completeArr = completeArr
        self.newViewModel = successSimilarArr
        self.failArr = failArr
        self.sourcePlatform = source
        self.destinationPlatform = destination
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setSimilarData()
        bindTableViewSelection() // 셀 선택 이벤트 바인딩
        observeSelectionChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(1100)
        }
        
        self.contentView.addSubview(similarTitleView)
        similarTitleView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(213)
        }
        
        self.similarTitleView.addSubview(sourceToDestinationLabel)
        sourceToDestinationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(46)
        }
        
        self.similarTitleView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(53)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(34)
            make.width.equalTo(34)
        }
        backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
        
        self.similarTitleView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(6)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(4)
        }
        progressView.updateProgress(to: 0.75)
        
        self.similarTitleView.addSubview(similarTitleLabel1)
        similarTitleLabel1.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(24)
        }
        
        self.similarTitleView.addSubview(similarTitleLabel2)
        similarTitleLabel2.snp.makeConstraints { make in
            make.top.equalTo(similarTitleLabel1.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
        }
        
        self.contentView.addSubview(similarSongView)
        similarSongView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(similarTitleView.snp.bottom)
        }
        
        self.similarSongView.addSubview(songCountLabel)
        songCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(38)
        }
        songCountLabel.text = "\(newViewModel.successArr.value.count)곡"
        
        self.similarSongView.addSubview(similarMusicTableView)
        similarMusicTableView.snp.makeConstraints { make in
            make.top.equalTo(songCountLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(102)
        }
        moveView.trasferButton.addTarget(self, action: #selector(clickTransferButton), for: .touchUpInside)
        self.moveView.changeName(left: "이전", right: "옮기기")
    }
    
    private func setSimilarData() {
        let dataSource = RxTableViewSectionedReloadDataSource<MusicSection>(
            configureCell: { [weak self] _, tableView, indexPath, item in
                guard let self = self else { return UITableViewCell() }
                
                switch item {
                case .success(let music):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: ValidationSimilarTableViewCell.identifier,
                        for: indexPath
                    ) as! ValidationSimilarTableViewCell
                    cell.prepare(music: music)
                    return cell
                    
                case .music(let music):
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: SimilarSongsTableViewCell.identifier,
                        for: indexPath
                    ) as! SimilarSongsTableViewCell
                    cell.prepare(music: music)
                    
                    let isSelected = self.newViewModel.selectedMusic.value.contains(music)
                    cell.updateSelectionUI(isSelected: isSelected)
                    return cell
                }
            },
            titleForHeaderInSection: { _, _ in
                return nil // 섹션 헤더 텍스트를 제거
            }
        )
        
        // 테이블 뷰에 바인딩
        newViewModel.sections
            .observe(on: MainScheduler.instance)
            .bind(to: self.similarMusicTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        similarMusicTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindTableViewSelection() {
        similarMusicTableView.rx.modelSelected(MusicSectionItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                
                switch item {
                case .success(let music), .music(let music):
                    var selectedMusics = self.newViewModel.selectedMusic.value
                    var selectedMusicIds = self.newViewModel.completeArr
                    
                    if let index = selectedMusics.firstIndex(of: music) {
                        // 이미 선택된 음악이라면, 선택 해제
                        selectedMusics.remove(at: index)
                        selectedMusicIds.remove(at: index)
                    } else {
                        // 새로운 음악 선택
                        selectedMusics.append(music)
                        selectedMusicIds.append(music.id ?? "")
                    }
                    
                    self.newViewModel.selectedMusic.accept(selectedMusics) // 선택된 음악 배열 업데이트
                    self.newViewModel.completeArr = selectedMusicIds
                    
                    print("현재 선택된 음악 목록: \(selectedMusicIds)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func observeSelectionChanges() {
        newViewModel.selectedMusic
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedMusic in
                guard let self = self else { return }
                
                self.similarMusicTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func clickXButton() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count > 5 {
                let previousViewController = viewControllers[viewControllers.count - 7]
                navigationController.popToViewController(previousViewController, animated: true)
            }
        }
    }
    
    @objc private func clickTransferButton() {
        let validationNotFoundVC = ValidationNotFoundViewController(completeArr: completeArr + newViewModel.completeArr, failArr: failArr, source: self.sourcePlatform!, destination: self.destinationPlatform)
        self.navigationController?.pushViewController(validationNotFoundVC, animated: true)
    }
}

extension ValidationSimilarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 { // 셀을 3개의 유형으로 나눠서 사용
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ValidationSimilarTableViewCell.identifier, for: indexPath) as? ValidationSimilarTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimilarSongsTableViewCell.identifier, for: indexPath) as? SimilarSongsTableViewCell else {
                return UITableViewCell()
            }
            return cell
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ValidationSimilarTableViewCell.identifier, for: indexPath) as? ValidationSimilarTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        
        newViewModel.sections
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { sections in
                if let section = sections[safe: indexPath.section] {
                    let item = section.items[safe: indexPath.row]
                    
                    // 섹션 아이템에 따라 높이를 설정
                    switch item {
                    case .success:
                        height = 66 // success 아이템에 해당하는 셀의 높이
                    case .music:
                        height = 58 // music 아이템에 해당하는 셀의 높이
                    case .none:
                        height = 100
                    }
                }
            })
            .disposed(by: disposeBag)
        
        return height
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}
