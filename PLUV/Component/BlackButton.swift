//
//  BlackButton.swift
//  PLUV
//
//  Created by 백유정 on 7/19/24.
//

import UIKit

@IBDesignable
final class BlackButton: UIButton {
    
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
        
        self.setTitleColor(.gray400, for: .disabled)
        self.setTitleColor(.white, for: .normal)
        
        self.setBackgroundColor(.gray300, for: .disabled)
        self.setBackgroundColor(.gray800, for: .normal)
    }
}

