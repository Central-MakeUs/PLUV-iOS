//
//  FeedDetailTableViewCell.swift
//  PLUV
//
//  Created by 백유정 on 10/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FeedDetailTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FeedDetailTableViewCell.self)
    private let contentsView = UIView()
    private let numberLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 15)
    }
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        // $0.layer.cornerRadius = 2
        $0.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        $0.layer.borderWidth = 0.5
        $0.clipsToBounds = true
    }
    private let labelView = UIView()
    private let songTitleLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 15) /// g, y, p 같은 문자 이슈로 1point 줄임
    }
    private let singerLabel = UILabel().then {
        $0.textColor = .gray500
        $0.font = .systemFont(ofSize: 13) /// g, y, p 같은 문자 이슈로 1point 줄임
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /// 셀을 재사용할 때 기본 상태로 초기화
        self.contentView.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.contentView.addSubview(contentsView)
        contentsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        self.contentsView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(contentsView)
            make.width.equalTo(thumbnailImageView.snp.height)
        }
        
        self.contentsView.addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview().inset(7)
        }
        
        self.labelView.addSubview(songTitleLabel)
        songTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(16)
        }
        
        self.labelView.addSubview(singerLabel)
        singerLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(14)
        }
    }
    
}

