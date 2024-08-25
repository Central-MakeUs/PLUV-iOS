//
//  DotView.swift
//  PLUV
//
//  Created by 백유정 on 8/6/24.
//

import UIKit

final class DotView: UIView {
    
    private var firstDotView = UIView().then {
        $0.backgroundColor = .gray300
        $0.clipsToBounds = true
    }
    
    private var secondDotView = UIView().then {
        $0.backgroundColor = .gray300
        $0.clipsToBounds = true
    }
    
    private var thirdDotView = UIView().then {
        $0.backgroundColor = .gray300
        $0.clipsToBounds = true
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        
        self.addSubview(firstDotView)
        self.firstDotView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(6)
        }
        
        self.addSubview(secondDotView)
        self.secondDotView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(6)
        }
        
        self.addSubview(thirdDotView)
        self.thirdDotView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(6)
        }
        
        super.layoutSubviews()
        
        firstDotView.layer.cornerRadius = firstDotView.frame.size.width / 2
        secondDotView.layer.cornerRadius = secondDotView.frame.size.width / 2
        thirdDotView.layer.cornerRadius = thirdDotView.frame.size.width / 2
    }
}
