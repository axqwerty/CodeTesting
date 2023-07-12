//
//  ViewController.swift
//  CodeTest
//
//  Created by Alex on 11/7/2023.
//

import UIKit

class ViewController: UIViewController {
    
    static let kDefaultBottomBarHeight:CGFloat = 80
    
    var tabVC: UITabBarController!
    var tabViewControllers: [UIViewController] = []
    
    lazy var homeTab: TabbarItem = {
        let tab = TabbarItem()
        let name = NSLocalizedString("home", comment: "name")
        tab.name = name
        tab.image = UIImage(systemName: "house")
        return tab
    }()
    
    lazy var favoriteTab: TabbarItem = {
        let tab = TabbarItem()
        let name = NSLocalizedString("favorite", comment: "favorite")
        tab.name = name
        tab.image = UIImage(systemName: "heart")
        return tab
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var tabs = [TabbarItem]()
    
    var currentTab: TabbarItem? {
        didSet {
            if let currentTab = currentTab {
                if let indexPath = getIndexPath(currentTab) {
                    setIndexPath(indexPath)
                    setSelectedTab(tab: currentTab)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 20, green: 20, blue: 36)
        setupTabVC()
        setupUI()
    }

    private func setupTabVC() {
        
        tabVC = UITabBarController()
        tabVC.tabBar.isHidden = true
        let home = HomeViewController()
        let favorite = FavoriteViewController()
        tabViewControllers.append(home)
        tabViewControllers.append(favorite)
        tabVC.viewControllers = tabViewControllers
    }
    
    func setupUI() {
        
        addChild(tabVC)
        
        tabs.append(contentsOf: [
            homeTab,
            favoriteTab
        ])
        
        view.addSubview(tabVC.view)
        view.addSubview(bottomView)
        bottomView.addSubview(stackView)
        
        setupConstraints()
        
        if let first = tabs.first {
            setSelectedTab(tab: first)
        }
    }
    
    func setupConstraints() {
        
        bottomView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.height.equalTo(Self.kDefaultBottomBarHeight)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(6)
        }
        
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
        }
        
        for (index, tab) in tabs.enumerated() {
            tab.tapActions = {
                self.setSelectedTab(tab: tab)
                self.switchToTab(tab)
            }
            
            if (index + 1) > 6 {
                continue
            } else {
                stackView.addArrangedSubview(tab)
            }
        }
        
    }
    
    func switchToTab(_ tabToSelect: TabbarItem) {
        
        currentTab = tabToSelect
    }
    
    func setSelectedTab(tab: TabbarItem, vc: UIViewController? = nil) {
        switch tab {
        default:
            tab.isSelected = true
            for t in tabs {
                if t == tab { continue }
                t.isSelected = false
            }
        }
    }
    
    func setIndexPath(_ indexPath: Int) {
        if tabVC != nil {
            tabVC.selectedIndex = indexPath
        }
    }
    
    func getIndexPath(_ tabToSelect: TabbarItem) -> Int? {
        
        guard let indexPath = (tabViewControllers.firstIndex { viewController in
            switch tabToSelect {
            case homeTab:
                return viewController is HomeViewController
            case favoriteTab:
                return viewController is FavoriteViewController
            default:
                return false
            }
        }) else { return nil }
        
        return indexPath
    }
}

