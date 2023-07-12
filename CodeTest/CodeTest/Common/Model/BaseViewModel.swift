//
//  BaseViewModel.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import Foundation
import RxCocoa
import RxSwift

class BaseViewModel {
    
    enum ViewModelState<T> {
        case loading
        case failure(String)
        case success(T)
    }
    
    let disposeBag = DisposeBag()
}
