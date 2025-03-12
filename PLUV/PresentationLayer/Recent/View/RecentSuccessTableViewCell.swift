//
//  RecentSuccessTableViewCell.swift
//  PLUV
//
//  Created by jaegu park on 11/7/24.
//

import UIKit

class RecentSuccessTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: RecentSuccessTableViewCell.self)
    
    private let indexLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let nameLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    private let artistLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .systemFont(ofSize: 14, weight: .regular)
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
        self.contentView.addSubview(indexLabel)
        indexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(16)
            make.height.equalTo(14)
        }
        
        self.contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalTo(indexLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.height.equalTo(16)
        }
        
        self.contentView.addSubview(artistLabel)
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.height.equalTo(14)
        }
    }
    
    func prepare(music: Music, index: Int) {
        self.indexLabel.text = "\(index + 1)"
        let thumbNailUrl = URL(string: music.imageURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.nameLabel.text = music.title
        self.artistLabel.text = music.artistNames
    }
}
