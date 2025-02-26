//
//  ActionBottomView.swift
//  PLUV
//
//  Created by 백유정 on 8/19/24.
//

import UIKit

final class ActionBottomView: UIView {
    
    var lineView = UIView()
    var actionButton = BlackButton()
    
    init(actionName: String) {
        super.init(frame: .zero)
        setUI(buttonText: actionName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(buttonText: String) {
        self.backgroundColor = .white
        
        self.addSubview(lineView)
        self.lineView.backgroundColor = .gray200
        lineView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(actionButton)
        self.actionButton.setTitle(buttonText, for: .normal)
        actionButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(24)
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
}
