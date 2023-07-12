//
//  MusicCell.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit
import RxSwift

class MusicCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    lazy var artistIcon: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var artistName: UILabel = {
        let view = UILabel()
        view.textColor = .white
        return view
    }()
    
    lazy var songName: UILabel = {
        let view = UILabel()
        view.textColor = .white
        return view
    }()
    
    lazy var likeButton: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "heart"))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.setupUI()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setupUI() {
        self.contentView.addSubview(artistIcon)
        self.contentView.addSubview(artistName)
        self.contentView.addSubview(songName)
        self.contentView.addSubview(likeButton)
    }
    
    func setupConstraints() {
        
        let margin: CGFloat = 16.0
        let iconW: CGFloat = 60.0
        artistIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(margin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(iconW)
        }
        artistIcon.layer.cornerRadius = 0.5*iconW
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(36)
        }
        
        artistName.snp.makeConstraints { make in
            make.leading.equalTo(artistIcon.snp.trailing).offset(margin)
            make.trailing.equalTo(likeButton.snp.leading).offset(-margin)
            make.top.equalTo(artistIcon).offset(6)
            make.height.equalTo(20)
        }
        
        songName.snp.makeConstraints { make in
            make.leading.equalTo(artistIcon.snp.trailing).offset(margin)
            make.trailing.equalTo(likeButton.snp.leading).offset(-margin)
            make.bottom.equalTo(artistIcon).offset(-6)
            make.height.equalTo(20)
        }
    }
    
}
