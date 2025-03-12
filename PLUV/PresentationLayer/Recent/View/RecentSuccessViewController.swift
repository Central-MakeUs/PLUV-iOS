//
//  ClassifySuccessViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa

class RecentSuccessViewController: UIViewController {
    
    private var viewModel = MeViewModel()
    private let disposeBag = DisposeBag()
    
    private let recentSuccessTableViewCell = UITableView().then {
        $0.separatorStyle = .none
        $0.register(RecentSuccessTableViewCell.self, forCellReuseIdentifier: RecentSuccessTableViewCell.identifier)
    }
    
    init(viewModel: MeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setSuccessAPI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(recentSuccessTableViewCell)
        recentSuccessTableViewCell.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setData() {
        self.recentSuccessTableViewCell.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        /// CollectionView에 들어갈 Cell에 정보 제공
        self.viewModel.selectMeMusicItem
            .observe(on: MainScheduler.instance)
            .bind(to: self.recentSuccessTableViewCell.rx.items(cellIdentifier: RecentSuccessTableViewCell.identifier, cellType: RecentSuccessTableViewCell.self)) { index, item, cell in
                cell.prepare(music: item, index: index)
            }
            .disposed(by: disposeBag)
        
        self.recentSuccessTableViewCell.reloadData()
        self.recentSuccessTableViewCell.layoutIfNeeded()
    }
    
    private func setSuccessAPI() {
        guard let id = self.viewModel.selectMeItem?.id else { return }
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        let url = EndPoint.historySuccess(String(id)).path
        
        APIService().getWithAccessToken(of: APIResponse<[Music]>.self, url: url, AccessToken: loginToken) { response in
            switch response.code {
            case 200:
                self.viewModel.selectMeMusicItem.accept(response.data)
                self.setData()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
}

extension RecentSuccessViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 66
   }
}
