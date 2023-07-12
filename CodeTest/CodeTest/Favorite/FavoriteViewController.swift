//
//  FavoriteViewController.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: BaseViewController {
    
    lazy var tableView:UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.estimatedRowHeight = 0
        view.estimatedSectionHeaderHeight = 0
        view.estimatedSectionFooterHeight = 0
        view.register(MusicCell.self, forCellReuseIdentifier: "MusicCell")
        view.contentInset.bottom = 100
        view.tableFooterView = UIView()
        return view
    }()
    
    let viewModel = HomeViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getLikes()
    }
    
    func setupUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
    }
    
    func setupBindings() {
        viewModel.likes.subscribe(onNext: { [weak self] resource in
            DispatchQueue.main.async {
                switch resource {
                    case .none:
                        break
                    case .loading:
                        self?.showLoading()
                    case .success:
                        self?.hideLoading()
                    case .error:
                        self?.hideLoading()
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "MusicCell", cellType: MusicCell.self)) { [weak self](row,item,cell) in
            if let url = item.artworkUrl60 {
                cell.artistIcon.kf.setImage(with: URL(string: url))
            }else{
                cell.artistIcon.image = nil
            }
            
            cell.artistName.text = item.artistName ?? ""
            cell.songName.text = item.collectionName ?? ""
            cell.likeButton.isHidden = true
            
        }.disposed(by: disposeBag)
        
            

    }
}

extension FavoriteViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
