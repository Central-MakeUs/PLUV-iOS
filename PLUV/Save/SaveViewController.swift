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
   
   let viewModel = FeedViewModel()

   private var saveDetailCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.minimumLineSpacing = 0
       layout.minimumInteritemSpacing = 0
       layout.scrollDirection = .vertical
       layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
       cv.register(SaveDetailCollectionViewCell.self, forCellWithReuseIdentifier: SaveDetailCollectionViewCell.identifier)
       
       return cv
   }()
   private let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setNavigationBar()
      setUI()
   }
   
   private func setNavigationBar() {
      /// NavigationBar의 back 버튼 이미지 변경
      let backImage = UIImage(named: "backbutton_icon")?.withRenderingMode(.alwaysOriginal)
      let resizedBackImage = backImage?.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: 24, height: 24))
      let backButton = UIBarButtonItem(image: resizedBackImage, style: .plain, target: self, action: #selector(clickBackButton))
      backButton.tintColor = .gray800
      navigationItem.leftBarButtonItem = backButton
      
      /// 커스터마이즈된 제목 뷰 추가
      let titleLabel = UILabel()
      titleLabel.text = "저장한 플레이리스트"
      titleLabel.textColor = UIColor.gray800
      titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
      titleLabel.sizeToFit()
      navigationItem.titleView = titleLabel
   }
   
   private func setUI() {
      self.view.backgroundColor = .white
      self.navigationItem.setHidesBackButton(true, animated: false)
      
      self.view.addSubview(saveDetailCollectionView)
      saveDetailCollectionView.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide)
         make.leading.trailing.bottom.equalToSuperview()
      }
      saveDetailCollectionView.showsVerticalScrollIndicator = false
      saveDetailCollectionView.allowsMultipleSelection = false
   }
   
   @objc private func clickBackButton() {
       self.navigationController?.popViewController(animated: true)
   }
   
   private func setData() {
      self.saveDetailCollectionView.rx.setDelegate(self)
         .disposed(by: disposeBag)
      
      /// CollectionView에 들어갈 Cell에 정보 제공
      self.viewModel.feedItems
         .observe(on: MainScheduler.instance)
         .bind(to: self.saveDetailCollectionView.rx.items(cellIdentifier: SaveDetailCollectionViewCell.identifier, cellType: SaveDetailCollectionViewCell.self)) { index, item, cell in
            cell.prepare(feed: item)
         }
         .disposed(by: disposeBag)
      
      /// 아이템 선택 시 다음으로 넘어갈 VC에 정보 제공
      self.saveDetailCollectionView.rx.modelSelected(Feed.self)
         .subscribe(onNext: { [weak self] feedItem in
            self?.viewModel.selectFeedItem = Observable.just(feedItem)
            
         })
         .disposed(by: disposeBag)
   }
   
   private func setFeedAPI() {
      let url = EndPoint.feed.path
      
      APIService().get(of: APIResponse<[Feed]>.self, url: url) { response in
         switch response.code {
         case 200:
            self.viewModel.feedItems = Observable.just(response.data)
            self.setData()
            self.view.layoutIfNeeded()
         default:
            AlertController(message: response.msg).show()
         }
      }
   }
}

@available(iOS 14.0, *)
extension SaveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 94)
    }
}