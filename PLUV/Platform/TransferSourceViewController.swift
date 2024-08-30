//
//  TransferSourceViewController.swift
//  PLUV
//
//  Created by 백유정 on 7/13/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TransferSourceViewController: UIViewController {
    
    private let sourceList = Observable.just(MusicPlatform.allCases)
    private let sourceTitleView = UIView()
    private let sourceTitleLabel = UILabel().then {
        $0.text = "어디에서\n플레이리스트를 불러올까요?"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .gray800
    }
    private let sourceTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(TransferTableViewCell.self, forCellReuseIdentifier: TransferTableViewCell.identifier)
    }
    private var moveView = MoveView(view: UIViewController())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension TransferSourceViewController {
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(sourceTitleView)
        sourceTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(124)
        }
        
        self.sourceTitleView.addSubview(sourceTitleLabel)
        sourceTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(28)
        }
        
        self.view.addSubview(sourceTableView)
        sourceTableView.snp.makeConstraints { make in
            make.top.equalTo(sourceTitleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        moveView = MoveView(view: self)
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(101)
        }
        
        moveView.backButton.isEnabled = false
        moveView.trasferButton.isEnabled = false
        
        // sourceTableView.isScrollEnabled = false
        
        setXButton()
    }
    
    private func setData() {
        self.sourceTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        /// 아이템 선택 시 스타일 제거
        self.sourceTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.sourceTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
        self.sourceTableView.rx.modelSelected(MusicPlatform.self)
                   .observe(on: MainScheduler.instance)
                   .subscribe(onNext: { [weak self] platform in
                       let transferDestinationVC = TransferDestinationViewController()
                       transferDestinationVC.sourcePlatform = platform
                       self?.navigationController?.pushViewController(transferDestinationVC, animated: true)
                   })
                   .disposed(by: disposeBag)
        
        /// TableView에 들어갈 Cell에 정보 제공
        self.sourceList
            .observe(on: MainScheduler.instance)
            .bind(to: self.sourceTableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: TransferTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! TransferTableViewCell
                cell.prepare(platform: item)
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setXButton() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clickXButton))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func clickXButton() {
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count > 1 {
                let previousViewController = viewControllers[viewControllers.count - 2]
                navigationController.popToViewController(previousViewController, animated: true)
            }
        }
    }
}

extension TransferSourceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
