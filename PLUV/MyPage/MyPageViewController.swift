//
//  MyPageViewController.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {
    
    private let myPageItemList = Observable.just(MyPageItem.allCases)
    private let titleView = UIView()
    private let myPageTitleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    private let myPageInfoButton = UIButton().then {
        $0.setImage(UIImage(named: "mypagebutton_info_image"), for: .normal)
        $0.setImage(UIImage(named: "mypagebutton_info_image"), for: .highlighted)
        $0.contentMode = .scaleAspectFit
    }
    private let nickNameLabel = UILabel().then {
        $0.text = "플러버"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    private let myPageTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
    }
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setUI() {
        self.view.backgroundColor = .gray100
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(myPageTitleLabel)
        myPageTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(titleView).inset(16)
            make.height.equalTo(28)
        }
        
        self.view.addSubview(myPageInfoButton)
        myPageInfoButton.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(106)
        }
        
        self.myPageInfoButton.addSubview(nickNameLabel)
        nickNameLabel.backgroundColor = .white
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(106)
            make.top.equalToSuperview().offset(23)
            make.trailing.equalToSuperview()
            make.height.equalTo(34)
        }
        
        self.view.addSubview(myPageTableView)
        myPageTableView.backgroundColor = .white
        myPageTableView.snp.makeConstraints { make in
            make.top.equalTo(myPageInfoButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setData() {
        myPageInfoButton.addTarget(self, action: #selector(clickMyPageInfoButton), for: .touchUpInside)
        
        self.myPageTableView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        /// 아이템 선택 시 스타일 제거
        self.myPageTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.myPageTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
        self.myPageTableView.rx.modelSelected(MyPageItem.self)
                   .observe(on: MainScheduler.instance)
                   .subscribe(onNext: { [weak self] myPageItem in
                       if myPageItem == .LogOut {
                           AlertController(message: "로그아웃 하시겠어요?", isCancel: true) {
                               let LoginVC = UINavigationController(rootViewController: LoginViewController())
                               SceneDelegate().setRootViewController(LoginVC)
                               self?.navigationController?.popToRootViewController(animated: true)
                           }.show()
                       } else {
                           let webVC = WebViewController()
                           webVC.urlString = myPageItem.url
                           self?.navigationController?.pushViewController(webVC, animated: true)
                       }
                   })
                   .disposed(by: disposeBag)
        
        /// TableView에 들어갈 Cell에 정보 제공
        self.myPageItemList
            .observe(on: MainScheduler.instance)
            .bind(to: self.myPageTableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier, for: IndexPath(row: row, section: 0)) as! MyPageTableViewCell
                cell.prepare(myPageItem: item)
                return cell
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc private func clickMyPageInfoButton() {
        let memberInfoViewController = MemberInfoViewController()
        self.navigationController?.pushViewController(memberInfoViewController, animated: true)
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
