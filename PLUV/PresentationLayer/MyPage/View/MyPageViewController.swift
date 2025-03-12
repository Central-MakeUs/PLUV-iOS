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
    private let disposeBag = DisposeBag()
    
    private let myPageTitleLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    private let myInfoView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.shadow.cgColor
        $0.layer.shadowOpacity = 0.9
        $0.layer.shadowRadius = 1.0
        $0.layer.shadowOffset = CGSize(width: 0, height: -2)
        $0.layer.masksToBounds = false
    }
    private let myInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "myinfo_image")
        $0.contentMode = .scaleAspectFit
    }
    private let nickNameLabel = UILabel().then {
        $0.text = "플러버"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 22, weight: .bold)
    }
    private let myInfoButton = UIButton().then {
        $0.setImage(UIImage(named: "nextbutton_icon"), for: .normal)
        $0.setTitle("회원 정보 ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitleColor(.gray600, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let myPageTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        getNicknameAPI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .gray100
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(myPageTitleLabel)
        myPageTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(57)
            make.leading.equalToSuperview().offset(16)
        }
        
        self.view.addSubview(myInfoView)
        myInfoView.snp.makeConstraints { make in
            make.top.equalTo(myPageTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(106)
        }
        
        self.myInfoView.addSubview(myInfoImageView)
        myInfoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(74)
        }
        
        self.myInfoView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalTo(myInfoImageView.snp.trailing).offset(16)
            make.height.equalTo(34)
        }
        
        self.myInfoView.addSubview(myInfoButton)
        myInfoButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(myInfoImageView.snp.trailing).offset(16)
            make.height.equalTo(16)
            make.width.equalTo(76)
        }
        myInfoButton.addTarget(self, action: #selector(clickMyPageInfoButton), for: .touchUpInside)
        
        self.view.addSubview(myPageTableView)
        myPageTableView.snp.makeConstraints { make in
            make.top.equalTo(myInfoView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setData() {
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
    
    private func getNicknameAPI() {
        let loginToken = UserDefaults.standard.string(forKey: APIService.shared.loginAccessTokenKey)!
        let url = EndPoint.memberNickname.path
        
        APIService().getWithAccessToken(of: APIResponse<String>.self, url: url, AccessToken: loginToken) { response in
            switch response.code {
            case 200:
                self.nickNameLabel.text = response.data
                self.view.layoutIfNeeded()
            default:
                AlertController(message: response.msg).show()
            }
        }
    }
    
    @objc private func clickMyPageInfoButton() {
        let memberInfoViewController = MemberInfoViewController()
        memberInfoViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memberInfoViewController, animated: true)
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}
