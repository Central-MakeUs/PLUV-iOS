//
//  RecentCollectionViewCell.swift
//  PLUV
//
//  Created by jaegu park on 10/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class RecentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: RecentCollectionViewCell.self)
    
    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let playButtonImageView = UIImageView().then {
        $0.image = UIImage(named: "playbutton_icon")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUI()
    }
    
    private func setUI() {
        self.contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.thumbnailImageView.addSubview(playButtonImageView)
        playButtonImageView.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(14)
            make.trailing.bottom.equalToSuperview().inset(6)
        }
    }
    
    func prepare(me: Me) {
        let thumbNailUrl = URL(string: me.imageURL)
        self.thumbnailImageView.kf.setImage(with: thumbNailUrl)
    }
}
