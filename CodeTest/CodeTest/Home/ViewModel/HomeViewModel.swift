//
//  HomeViewModel.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import RxSwift
import RxCocoa
import UIKit
import MJRefresh
import Alamofire

class HomeViewModel {
    
    let searchText = BehaviorRelay(value: "")
    let currentPage = BehaviorRelay(value: 0)
    let results = BehaviorRelay(value: [MusicModel]())
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<String>()
    let refreshStatus = BehaviorRelay(value: MJRefreshState.idle)
    let likes: BehaviorRelay<Resource<[MusicModel]>> = .init(value: .none)
    let items = PublishSubject<[MusicModel]>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[MusicModel]> in
                guard let self = self else { return .empty() }
                if query.isEmpty {
                    self.currentPage.accept(0)
                    self.error.onNext("")
                    return .just([])
                } else {
                    return self.requestData(page: 0, query: query)
                }
            }
            .subscribe(onNext: { [weak self] newResults in
                guard let self = self else { return }
                self.results.accept(newResults)
            }, onError: { [weak self] error in
                self?.error.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        currentPage
            .flatMapLatest { [weak self] page -> Observable<[MusicModel]> in
                guard let self = self, !self.searchText.value.isEmpty else { return .empty() }
                return self.requestData(page: page, query: self.searchText.value)
            }
            .subscribe(onNext: { [weak self] newResults in
                guard let self = self else { return }
                let currentResults = self.results.value
                self.results.accept(currentResults + newResults)
                self.refreshStatus.accept(.idle)
            }, onError: { [weak self] error in
                self?.error.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData(page: Int, query: String) -> Observable<[MusicModel]> {

        //    https://itunes.apple.com/search?term=jack+johnson&offset=20&limit=20.

        let pageSize: Int = 20
        let offset = pageSize * currentPage.value

        let parameters: Parameters = [
            "term": query,
            "offset": offset,
            "limit": pageSize
        ]

//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json",
//            "Accept":"text/javascript"
//        ]

        let hostUrl = "https://itunes.apple.com/search?"
        
        return Observable.create { observer in
                let request = AF.request(hostUrl, parameters: parameters)
                    .validate()
                    .responseDecodable(of: MusicResultModel.self) { response in
                        switch response.result {
                        case .success(let results):
                            if let data = results.results {
                                observer.onNext(data)
                            }else{
                                observer.onNext([])
                                self.refreshStatus.accept(.noMoreData)
                            }
                            
                            observer.onCompleted()
                        case .failure(_):
                            observer.onNext([])
                            self.refreshStatus.accept(.noMoreData)
                        }
                    }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func loadMore() {
        currentPage.accept(currentPage.value + 1)
    }
    
    func refresh() {
        currentPage.accept(0)
    }
    
    func getLikes() {
        likes.accept(.loading)
        if let likesArray = MusicModel.getAllFavoriteFromUserDefaults() {
            likes.accept(.success(data: likesArray))
            items.onNext(likesArray)
        }else{
            likes.accept(.error(errorCode: "no data"))
            items.onNext([])
        }
    }
}

