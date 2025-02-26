//
//  SaveMoveView.swift
//  PLUV
//
//  Created by jaegu park on 10/27/24.
//

import UIKit
import Then

final class SaveMoveView: UIView {
    
    weak var feedDelegate: SaveMoveViewFeedDelegate?
    weak var saveDelegate: SaveMoveViewSaveDelegate?
    
    private let saveButton = UIButton().then {
        $0.setImage(UIImage(named: "savebutton_icon"), for: .normal)
    }
    private let saveLabel = UILabel().then {
        $0.text = "저장"
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    var trasferButton = BlackButton()
    var view: UIViewController
    
    private var isOriginalColor: Bool = true
    
    init(view: UIViewController) {
        self.view = view
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = .white
        
        self.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        saveButton.addTarget(self, action: #selector(saveButtonColor), for: .touchUpInside)
        
        self.addSubview(saveLabel)
        saveLabel.snp.makeConstraints { make in
            make.centerY.equalTo(saveButton)
            make.leading.equalTo(saveButton.snp.trailing)
            make.width.equalTo(28)
            make.height.equalTo(16)
        }
        
        self.addSubview(trasferButton)
        self.trasferButton.setTitle("플레이리스트 옮기기", for: .normal)
        trasferButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(saveLabel.snp.trailing).offset(35)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        trasferButton.addTarget(self, action: #selector(transferButtonTapped), for: .touchUpInside)
        
        shadow()
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.shadow.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    
    @objc func saveButtonColor() {
        if isOriginalColor {
            saveButton.setImage(UIImage(named: "savebutton_icon2"), for: .normal)
            feedDelegate?.setFeedSaveAPI()
            saveDelegate?.setFeedSaveAPI()
        } else {
            saveButton.setImage(UIImage(named: "savebutton_icon"), for: .normal)
            feedDelegate?.deleteFeedSaveAPI()
            saveDelegate?.deleteFeedSaveAPI()
        }
        isOriginalColor.toggle()
    }
    
    @objc func transferButtonTapped() {
        feedDelegate?.transferFeed()
        saveDelegate?.transferFeedSave()
    }
    
    func updateSaveButtonImage(isSaved: Bool) {
        let imageName = isSaved ? "savebutton_icon" : "savebutton_icon2"
        saveButton.setImage(UIImage(named: imageName), for: .normal)
        isOriginalColor = isSaved
    }
}
