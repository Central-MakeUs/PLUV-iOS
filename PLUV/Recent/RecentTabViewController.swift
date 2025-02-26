//
//  RecentTabViewController.swift
//  PLUV
//
//  Created by jaegu park on 10/26/24.
//

import UIKit
import Tabman
import Pageboy

class RecentTabViewController: TabmanViewController {
   
    private var viewModel = MeViewModel()
    
   private var viewControllers: Array<UIViewController> = []
   
   private let tabView = UIView().then {
      $0.backgroundColor = .white
   }
   private let backgroundLabel2 = UILabel().then {
      $0.backgroundColor = .gray200
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
      setupTabMan()
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
      
      self.view.addSubview(tabView)
      tabView.snp.makeConstraints { make in
         make.leading.trailing.top.equalToSuperview()
         make.height.equalTo(44)
      }
      
      self.tabView.addSubview(backgroundLabel2)
      backgroundLabel2.snp.makeConstraints { make in
         make.leading.trailing.bottom.equalToSuperview()
         make.height.equalTo(1.5)
      }
   }
   
   private func setupTabMan() {
       let vc1 = RecentSuccessViewController(viewModel: self.viewModel)
       let vc2 = RecentFailViewController(viewModel: self.viewModel)
      
      viewControllers.append(vc1)
      viewControllers.append(vc2)
      
      self.dataSource = self
      
      let bar = TMBar.ButtonBar()
      // 배경 회색으로 나옴 -> 하얀색으로 바뀜
      bar.backgroundView.style = .clear
      // 간격 설정
      bar.layout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      // 버튼 글씨 커스텀
      bar.buttons.customize { (button) in
         button.tintColor = .gray400
         button.selectedTintColor = UIColor(red: 0.619, green: 0.135, blue: 1, alpha: 1)
         button.font = .systemFont(ofSize: 16, weight: .semibold)
         button.selectedFont = .systemFont(ofSize: 16, weight: .semibold)
      }
      
      bar.layout.contentMode = .fit
      
      // 밑줄 쳐지는 부분
      bar.indicator.weight = .custom(value: 3)
      bar.indicator.tintColor = UIColor(red: 0.619, green: 0.135, blue: 1, alpha: 1)
      addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
   }
}

extension RecentTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
   
   func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
      switch index {
      case 0:
         return TMBarItem(title: "옮긴 곡")
      case 1:
         return TMBarItem(title: "안 옮긴 곡")
      default:
         let title = "Page \(index)"
         return TMBarItem(title: title)
      }
   }
   
   func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
      return viewControllers.count
   }
   
   func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
      return viewControllers[index]
   }
   
   func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
      return nil
   }
}
