//
//  WhiteButton.swift
//  PLUV
//
//  Created by 백유정 on 7/19/24.
//

import UIKit

final class WhiteButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray300.cgColor
        
        self.setTitleColor(.gray300, for: .disabled)
        self.setTitleColor(.gray800, for: .normal)
    }
}
