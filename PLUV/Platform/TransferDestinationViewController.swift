//
//  TransferDestinationViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/19/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
class TransferDestinationViewController: UIViewController {
    
    var sourcePlatform: MusicPlatform? {
        didSet {
            updatePlatformView()
        }
    }
    var fromPlatform: LoadPluv? {
        didSet {
            updatePlatformView()
        }
    }
    
    var meViewModel = SelectMeViewModel()
    var saveViewModel = SelectSaveViewModel()
    
    private var destinationList = Observable.just(MusicPlatform.allCases)
    
    private let destinationTitleView = UIView()
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
    }
    private let progressView = CustomProgressView()
    private let destinationTitleLabel = UILabel().then {
        $0.text = "어디로\n플레이리스트를 옮길까요?"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .gray800
    }
    
    private lazy var selectSourcePlatformView = PlatformView(platform: MusicPlatform.AppleMusic)
    private let dotView = DotView()
    
    private let destinationTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(TransferTableViewCell.self, forCellReuseIdentifier: TransferTableViewCell.identifier)
    }
    
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setData()
        updatePlatformView()
    }
    
    private func updatePlatformView() {
        // sourcePlatform이 변경되었는지 확인하고 설정
        if let updatedSourcePlatform = sourcePlatform as PlatformRepresentable? {
            selectSourcePlatformView.setUI(updatedSourcePlatform)
        } else if let updatedFromPlatform = fromPlatform as PlatformRepresentable? {
            selectSourcePlatformView.setUI(updatedFromPlatform)
        }
    }
}

extension TransferDestinationViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(destinationTitleView)
        destinationTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(213)
        }
        
        self.destinationTitleView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(53)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(34)
            make.width.equalTo(34)
        }
        backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
        
        self.destinationTitleView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(6)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(4)
        }
        progressView.updateProgress(to: 0.25)
        
        self.destinationTitleView.addSubview(destinationTitleLabel)
        destinationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(68)
        }
        
        self.view.addSubview(selectSourcePlatformView)
        selectSourcePlatformView.snp.makeConstraints { make in
            make.top.equalTo(destinationTitleView.snp.bottom).offset(4)
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
        
        self.view.addSubview(destinationTableView)
        destinationTableView.snp.makeConstraints { make in
            make.top.equalTo(dotView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        moveView.trasferButton.isEnabled = false
        
        destinationTableView.isScrollEnabled = false
    }
    
    private func setData() {
        var platformList = MusicPlatform.allCases
        platformList.removeAll { platform in
            if sourcePlatform == platform {
                return true
            }
            return false
        }
        
        self.destinationList = Observable.just(platformList)
        
        self.destinationTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        self.destinationTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.destinationTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.destinationTableView.rx.modelSelected(MusicPlatform.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] platform in
                let transferCheckVC = TransferCheckViewController()
                if let updatedSourcePlatform = self!.sourcePlatform {
                    transferCheckVC.sourcePlatform = updatedSourcePlatform
                } else if let updatedFromPlatform = self!.fromPlatform {
                    transferCheckVC.sourcePlatform = updatedFromPlatform
                }
                transferCheckVC.destinationPlatform = platform
                if self?.saveViewModel.saveItem != nil {
                    transferCheckVC.saveViewModel.saveItem = self?.saveViewModel.saveItem
                } else if self?.meViewModel.meItem != nil {
                    transferCheckVC.meViewModel.meItem = self?.meViewModel.meItem
                }
                self?.navigationController?.pushViewController(transferCheckVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.destinationList
            .bind(to: self.destinationTableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TransferTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! TransferTableViewCell
                cell.prepare(platform: item)
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc private func clickXButton() {
        var moveStopView = MoveStopView(title: "지금 중단하면 진행 사항이 사라져요.", target: self, num: 3)
        if self.saveViewModel.saveItem != nil || self.meViewModel.meItem != nil {
            moveStopView = MoveStopView(title: "지금 중단하면 진행 사항이 사라져요.", target: self, num: 1)
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
}

extension TransferDestinationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
