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
   
    private let numberLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 15)
    }
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.gray300.cgColor
        $0.layer.borderWidth = 0.5
        $0.clipsToBounds = true
    }
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

    override func layoutSubviews() {
        setUI()
    }

    private func setUI() {
       self.contentView.addSubview(numberLabel)
       numberLabel.snp.makeConstraints { make in
          make.leading.equalToSuperview().offset(20)
          make.centerY.equalToSuperview()
          make.width.equalTo(16)
          make.height.equalTo(14)
       }
       
       self.contentView.addSubview(thumbnailImageView)
       thumbnailImageView.snp.makeConstraints { make in
          make.leading.equalTo(numberLabel.snp.trailing).offset(10)
          make.centerY.equalToSuperview()
          make.width.equalTo(50)
          make.height.equalTo(50)
       }
       
       self.contentView.addSubview(songTitleLabel)
       songTitleLabel.snp.makeConstraints { make in
          make.top.equalToSuperview().offset(15)
          make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
          make.height.equalTo(16)
       }
       
       self.contentView.addSubview(singerLabel)
       singerLabel.snp.makeConstraints { make in
          make.top.equalTo(songTitleLabel.snp.bottom).offset(6)
          make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
          make.height.equalTo(14)
       }
    }

    func prepare(music: Music, index: Int) {
       self.numberLabel.text = "\(index + 1)"
        let thumbNailUrl = URL(string: music.imageURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
        self.songTitleLabel.text = music.title
        self.singerLabel.text = music.artistNames
    }
}
