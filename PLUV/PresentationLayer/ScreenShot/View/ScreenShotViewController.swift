//
//  ScreenShotViewController.swift
//  PLUV
//
//  Created by jaegu park on 1/20/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ScreenShotViewController: UIViewController {
    
    private let viewModel = ScreenShotPlaylistViewModel()
    
    private let screenShotTitleView = UIView()
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "xbutton_icon"), for: .normal)
    }
    private let progressView = CustomProgressView()
    private let screenShotTitleLabel = UILabel().then {
        $0.text = "플레이리스트의\n스크린샷을 업로드해주세요."
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
        $0.textColor = .gray800
    }
    private let backgroundView = UIView().then {
        $0.backgroundColor = .gray100
    }
    private let screenShotView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor // 그림자 색상 설정
        $0.layer.shadowOpacity = 0.1 // 그림자 투명도 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0.5) // 그림자 위치 설정
        $0.layer.shadowRadius = 2 // 그림자 반경 설정
        $0.layer.cornerRadius = 8
    }
    private let screenShotImageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let imageAddButton = UIButton().then {
        $0.setImage(UIImage(named: "imageAdd_image"), for: .normal)
    }
    private let imageDeleteButton = UIButton().then {
        $0.setImage(UIImage(named: "imageDelete_image"), for: .normal)
        $0.isHidden = true
        $0.isEnabled = false
    }
    private let buttonView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor // 그림자 색상 설정
        $0.layer.shadowOpacity = 0.1 // 그림자 투명도 설정
        $0.layer.shadowOffset = CGSize(width: 0, height: 0.5) // 그림자 위치 설정
        $0.layer.shadowRadius = 2 // 그림자 반경 설정
    }
    private let uploadButton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.setTitle("업로드 완료", for: .normal)
        $0.setTitle("업로드 완료", for: .disabled)
        $0.setTitleColor(.gray400, for: .disabled)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.gray300, for: .disabled)
        $0.setBackgroundColor(.gray800, for: .normal)
    }
    private let tipView = UIView().then {
        $0.backgroundColor = .blueLight
        $0.layer.cornerRadius = 12
    }
    private let tipLabel = UILabel().then {
        $0.text = "Tip!"
        $0.font = .systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .subBlue
    }
    private let descriptionLabel = UILabel().then {
        $0.text = "플레이리스트의 음악의 앨범 커버, 곡명, 가수명이\n포함되도록 해주세요!"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .gray600
    }
    private let triangleImageView = UIImageView().then {
        $0.image = UIImage(named: "blackTriangle_image")
    }
    private let blackBubbleView = UIView().then {
        $0.backgroundColor = .blackNine
        $0.layer.cornerRadius = 4
    }
    private let bubbleLabel = UILabel().then {
        $0.text = "업로드 방법을 확인해주세요!"
        $0.font = .systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .white
    }
    private let bubbleXButton = UIButton().then {
        $0.setImage(UIImage(named: "whiteXbutton_icon"), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 탭 바 숨기기
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(screenShotTitleView)
        screenShotTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(221)
        }
        
        self.screenShotTitleView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(53)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(34)
            make.width.equalTo(34)
        }
        backButton.addTarget(self, action: #selector(clickXButton), for: .touchUpInside)
        
        self.screenShotTitleView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(6)
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(4)
        }
        progressView.updateProgress(to: 0.125)
        
        self.screenShotTitleView.addSubview(screenShotTitleLabel)
        screenShotTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(68)
        }
        
        self.view.addSubview(buttonView)
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(102)
        }
        
        self.buttonView.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        uploadButton.isEnabled = false
        uploadButton.addTarget(self, action: #selector(screenShotMusicAPI), for: .touchUpInside)
        
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(screenShotTitleView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(buttonView.snp.top)
        }
        
        self.backgroundView.addSubview(tipView)
        tipView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(72)
        }
        
        self.tipView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        self.tipView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tipLabel)
            make.leading.equalTo(tipLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        self.backgroundView.addSubview(triangleImageView)
        triangleImageView.snp.makeConstraints { make in
            make.bottom.equalTo(tipView.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(6)
            make.width.equalTo(10)
        }
        
        self.backgroundView.addSubview(blackBubbleView)
        blackBubbleView.snp.makeConstraints { make in
            make.bottom.equalTo(triangleImageView.snp.top)
            make.centerX.equalTo(triangleImageView)
            make.height.equalTo(31)
        }
        
        self.blackBubbleView.addSubview(bubbleXButton)
        bubbleXButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(16)
        }
        bubbleXButton.addTarget(self, action: #selector(deleteBubble), for: .touchUpInside)
        
        self.blackBubbleView.addSubview(bubbleLabel)
        bubbleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bubbleXButton.snp.leading).inset(-4)
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalTo(bubbleXButton)
            make.height.equalTo(19)
        }
        
        self.backgroundView.addSubview(screenShotView)
        screenShotView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(92)
            make.bottom.equalTo(tipView.snp.top).inset(-76)
        }
        
        self.screenShotView.addSubview(screenShotImageView)
        screenShotImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.screenShotView.addSubview(imageAddButton)
        imageAddButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        imageAddButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        
        self.screenShotView.addSubview(imageDeleteButton)
        imageDeleteButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        imageDeleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }

    @objc private func clickXButton() {
        let moveStopView = MoveStopView(title: "지금 중단하면 진행 사항이 사라져요.", target: self, num: 2)
        
        self.view.addSubview(moveStopView)
        moveStopView.alpha = 0
        moveStopView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            moveStopView.alpha = 1
        }
    }
    
    @objc private func addImage() {
        showActionSheet()
    }
    
    @objc private func deleteBubble() {
        UIView.animate(withDuration: 0.3, animations: {
            self.triangleImageView.alpha = 0
            self.blackBubbleView.alpha = 0
        }) { _ in
            self.triangleImageView.removeFromSuperview() // 애니메이션 후 뷰에서 제거
            self.blackBubbleView.removeFromSuperview()
        }
    }
    
    @objc private func deleteImage() {
        screenShotImageView.image = nil
        imageAddButton.isHidden = false
        imageAddButton.isEnabled = true
        imageDeleteButton.isHidden = true
        imageDeleteButton.isEnabled = false
        uploadButton.isEnabled = false
    }
    
    @objc private func screenShotMusicAPI() {
        let transferDestinationVC = TransferDestinationViewController()
        transferDestinationVC.screenShotPlatform = .FromScreenShot
        self.navigationController?.pushViewController(transferDestinationVC, animated: true)
//        let url = EndPoint.playlistOcrRead.path
//        var params: [String: Any] = [:]
//        
//        if let image = screenShotImageView.image {
//            if let base64String = convertImageToBase64(image: image, format: "png") {
//                params = ["base64EncodedImages" : base64String] as [String : Any]
//            } else {
//                print("Failed to encode image to Base64")
//            }
//        }
//        
//        APIService().post(of: APIResponse<[Music]>.self, url: url, parameters: params) { response in
//            switch response.code {
//            case 200:
//                self.viewModel.musicItem.accept(response.data)
//                self.view.layoutIfNeeded()
//            default:
//                AlertController(message: response.msg).show()
//            }
//        }
    }
}

extension ScreenShotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary // 앨범
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("앨범에 접근할 수 없습니다.")
        }
    }
    
    private func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let choosePhotoAction = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in
            self.openPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(choosePhotoAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            screenShotImageView.image = selectedImage // 이미지 뷰에 촬영하거나 가져온 사진을 출력
            imageAddButton.isHidden = true
            imageAddButton.isEnabled = false
            imageDeleteButton.isHidden = false
            imageDeleteButton.isEnabled = true
            uploadButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
