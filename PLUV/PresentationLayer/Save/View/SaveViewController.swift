//
//  SaveViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SaveViewController: UIViewController {
    
    private let viewModel = SaveViewModel()
    private let disposeBag = DisposeBag()
    
    private let navigationbarView = NavigationBarView(title: "저장한 플레이리스트")
    private let saveTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(SaveTableViewCell.self, forCellReuseIdentifier: SaveTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setSaveAPI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationbarView.delegate = self
        self.view.addSubview(navigationbarView)
        navigationbarView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        
        self.view.addSubview(saveTableView)
        saveTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationbarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setData() {
        saveTableView.delegate = nil
        saveTableView.dataSource = nil
        
        saveTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.viewModel.saveItems
            .observe(on: MainScheduler.instance)
            .bind(to: self.saveTableView.rx.items(cellIdentifier: SaveTableViewCell.identifier, cellType: SaveTableViewCell.self)) { index, item, cell in
                cell.prepare(feed: item)
            }
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
        self.saveTableView.rx.modelSelected(Feed.self)
            .subscribe(onNext: { [weak self] saveItem in
                guard let self = self else { return }
                self.viewModel.selectSaveItem = saveItem
                let saveDetailVC = SaveDetailViewController(viewModel: self.viewModel)
                self.navigationController?.pushViewController(saveDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setSaveAPI() {
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        let url = EndPoint.feedSave.path
        
        APIService().getWithAccessToken(of: APIResponse<[Feed]>.self, url: url, AccessToken: loginToken) { response in
            switch response.code {
            case 200:
                self.viewModel.saveItems = Observable.just(response.data)
                print(self.viewModel.saveItems)
                self.setData()
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
}

extension SaveViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}
