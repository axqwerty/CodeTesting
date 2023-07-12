//
//  TabbarItem.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit
import SnapKit

public class TabbarItem: UIView {
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        return view
    }()
    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()
    lazy var button: UIButton = {
        let view = UIButton()
        return view
    }()
    
    
    public var image: UIImage? {
        get {
            return imageView.image
        }
        set(val) {
            imageView.image = val?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    public var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    // MARK: - Action
    public var tapActions: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        
        addSubview(button)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.centerX.equalToSuperview()
            make.top.equalTo(2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(1)
            make.leading.equalTo(2)
            make.trailing.equalTo(2)
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //no highlight
        let gestur = UITapGestureRecognizer.init(target: self, action:#selector(handleTap))
        button.addGestureRecognizer(gestur)
        
    }
    
    convenience init(view:UIView, topCenter:CGPoint) {
        self.init(frame: .zero)
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var isSelected: Bool = false {
        didSet {
            imageView.isHighlighted = isSelected
            nameLabel.textColor = isSelected ? .white : .lightGray
            imageView.tintColor = nameLabel.textColor
        }
        
    }
    
    @objc func handleTap() {
        if let _ = tapActions {
            self.tapActions?()
        }
    }
    
}
