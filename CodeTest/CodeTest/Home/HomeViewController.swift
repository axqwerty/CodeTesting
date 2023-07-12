//
//  HomeViewController.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import Kingfisher
import RxGesture
import Foundation

class HomeViewController: BaseViewController {
    
    lazy var searchBar: TopSearchBar = {
        let view = TopSearchBar()
        view.searchTextFeild.tintColor = .black
        view.searchTextFeild.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        let str = NSLocalizedString("search_placeholder", comment: "placeholder")
        view.searchTextFeild.attributedPlaceholder = NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return view
    }()
    
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
//        setupRefresh()
        setupBindings()
    }
    
    func setupUI() {
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(90)
            make.height.equalTo(40)
        }
        
        searchBar.layer.cornerRadius = 20.0
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16.0)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
    }
    
    private func setupRefresh() {
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            self?.viewModel.loadMore()
        })
        
        viewModel.refreshStatus
            .bind(onNext: { [weak footer] status in
                switch status {
                case .idle:
                    footer?.endRefreshing()
                case .refreshing:
                    footer?.endRefreshing()
                case .noMoreData:
                    footer?.endRefreshingWithNoMoreData()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        tableView.mj_footer = footer
        tableView.mj_header = nil
    }
    
    func setupBindings() {
        
        searchBar.searchTextFeild.rx.text.orEmpty
                    .bind(to: viewModel.searchText)
                    .disposed(by: disposeBag)
        
        
        viewModel.results
            .bind(to: tableView.rx.items(cellIdentifier: "MusicCell", cellType: MusicCell.self)) { [weak self](row,item,cell) in
                
                DispatchQueue.main.async {
                    if let url = item.artworkUrl60 {
                        cell.artistIcon.kf.setImage(with: URL(string: url))
                    }else{
                        cell.artistIcon.image = nil
                    }
                    
                    cell.artistName.text = item.artistName ?? ""
                    cell.songName.text = item.collectionName ?? ""
                    if self?.tableView.mj_footer == nil {
                        self?.setupRefresh()
                    }
                    
                    let likes = MusicModel.getAllFavoriteFromUserDefaults()
                    var isLike: Bool = false
                    if let _ = likes?.first(where: {$0.artistId == item.artistId && $0.collectionId == item.collectionId && $0.trackId == item.trackId}) {
                        isLike = true
                    }
                    
                    cell.likeButton.image = isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
                    
                    cell.likeButton.rx.tapGesture().when(.recognized).subscribe { [weak self] _ in
                            self?.toLike(cell: cell, item: item)
                    }.disposed(by: cell.disposeBag)
                }
                
            }.disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { [weak self] error in
                self?.tableView.mj_footer?.endRefreshing()
                self?.tableView.mj_footer = nil
            })
            .disposed(by: disposeBag)
    }
    
    func toLike(cell:MusicCell, item:MusicModel) {
        let unLikeImage = UIImage(systemName: "heart")
        if cell.likeButton.image == unLikeImage {
            item.saveFavoriteToUserDefaults(favorite: item)
            let likeImage = UIImage(systemName: "heart.fill")
            cell.likeButton.image = likeImage
        }else{
            item.deleteFavoriteToUserDefaults(delete: item)
            let likeImage = UIImage(systemName: "heart")
            cell.likeButton.image = likeImage
        }
    }
}

extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}



