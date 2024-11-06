//
//  MoveView.swift
//  PLUV
//
//  Created by 백유정 on 7/19/24.
//

import UIKit

final class MoveView: UIView {
    
    var lineView = UIView()
    var backButton = WhiteButton()
    var trasferButton = BlackButton()
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = .white
        
        self.addSubview(lineView)
        self.lineView.backgroundColor = .gray200
        lineView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(backButton)
        self.backButton.setTitle("이전", for: .normal)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(58)
            make.width.equalTo(92)
        }
        
        self.addSubview(trasferButton)
        self.trasferButton.setTitle("옮기기", for: .normal)
        trasferButton.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.top)
            make.leading.equalTo(backButton.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(58)
        }
        
        shadow()
    }
    
    func shadow() {
        self.layer.shadowColor = UIColor.shadow.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
   
   func setBackButtonTarget(target: UIViewController) {
      backButton.addTarget(target, action: #selector(target.popViewController), for: .touchUpInside)
   }
}
