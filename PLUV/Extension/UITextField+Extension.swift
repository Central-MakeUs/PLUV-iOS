//
//  UITextField+Extension.swift
//  PLUV
//
//  Created by jaegu park on 12/20/24.
//

import UIKit

public extension UITextField {
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
    
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func errorfix() {
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}
