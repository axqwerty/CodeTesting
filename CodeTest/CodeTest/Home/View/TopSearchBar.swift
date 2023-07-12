//
//  TopSearchBar.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit

class TopSearchBar: UIView, UIGestureRecognizerDelegate,UITextFieldDelegate {
    
    lazy var searchTextFeild: UITextField = {
        let view = UITextField()
        view.delegate = self
        return view
    }()
    
    lazy var closeIcon: UIImageView = {
        let image = UIImage(systemName: "xmark.circle.fill")
        let colorImage = image?.imageWithColor(.lightGray)
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = colorImage
        view.alpha = 0.0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var searchIcon: UIImageView = {
        let image = UIImage(named: "ic_deals_search")
        let colorImage = image?.imageWithColor(.gray)
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = colorImage
        return view
    }()
    
    let keyboardDismissGestureRecognizer = UITapGestureRecognizer()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(TopSearchBar.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TopSearchBar.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TopSearchBar.textDidChange(_:)), name: UITextField.textDidChangeNotification, object: searchTextFeild)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: self.searchTextFeild)
    }
    
    private func setupUI() {
        
        self.backgroundColor = .white
        
        addSubview(searchTextFeild)
        addSubview(closeIcon)
        addSubview(searchIcon)
        
        let iconW: CGFloat = 24.0
        let margin: CGFloat = 16.0
        
        searchTextFeild.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(margin)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-(iconW + margin))
        }
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-margin)
            make.width.height.equalTo(iconW)
        }
        
        closeIcon.snp.makeConstraints { make in
            make.center.equalTo(searchIcon)
            make.width.height.equalTo((iconW - 6))
        }
        
        let gestur = UITapGestureRecognizer.init(target: self, action:#selector(clickOnClose))
        closeIcon.addGestureRecognizer(gestur)
        
        keyboardDismissGestureRecognizer.addTarget(self, action: #selector(TopSearchBar.dismissKeyboard(_:)))
        keyboardDismissGestureRecognizer.cancelsTouchesInView = false
        keyboardDismissGestureRecognizer.delegate = self
        
    }
    
    @objc func clickOnClose() {
        self.searchTextFeild.text = nil
        self.searchTextFeild.sendActions(for: .allEditingEvents)
    }
    
    @objc func keyboardWillShow(_ notification: Notification?) {
        if self.searchTextFeild.isFirstResponder {
            self.window?.rootViewController?.view.addGestureRecognizer(self.keyboardDismissGestureRecognizer)
            self.refreshIcons()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification?) {
        if self.searchTextFeild.isFirstResponder {
            self.window?.rootViewController?.view.addGestureRecognizer(self.keyboardDismissGestureRecognizer)
        }
    }
    
    @objc func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        if (self.searchTextFeild.isFirstResponder) {
            self.window?.endEditing(true)
            self.closeIcon.alpha = 0.0
            self.searchIcon.alpha = 1.0
        }
    }
    
    private func refreshIcons() {
        let hasText: Bool = self.searchTextFeild.text!.count != 0
        
        if hasText {
            self.closeIcon.alpha = 1.0
            self.searchIcon.alpha = 0.0
        }
        else {
            self.closeIcon.alpha = 0.0
            self.searchIcon.alpha = 1.0
        }
    }
    
// MARK: text filed
    @objc func textDidChange(_ notification: Notification?) {
        self.refreshIcons()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let retVal: Bool = true;
        
        return retVal
    }
    
// MARK: gesture
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var retVal: Bool = true
        
        if self.bounds.contains(touch.location(in: self)) {
            retVal = false
        }
        
        return retVal
    }
}
