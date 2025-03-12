//
//  MyPageTableViewCell.swift
//  PLUV
//
//  Created by 백유정 on 8/30/24.
//

import UIKit

final class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: MyPageTableViewCell.self)
    
    private let titleLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    private let separatorView = UIView().then {
        $0.backgroundColor = .gray200
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1.2)
        }
    }
    
    func prepare(myPageItem: MyPageItem) {
        self.titleLabel.text = myPageItem.text
    }
}
