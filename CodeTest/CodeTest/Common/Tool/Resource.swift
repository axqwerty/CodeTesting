//
//  Resource.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import Foundation

public enum Resource<T> {
    case none, loading, success(data: T), error(errorCode: String)
    
    var uniqueRepresentation: Int {
        switch self {
        case .none:
            return 0
        case .loading:
            return 1
        case .success:
            return 2
        case .error:
            return 3
        }
    }
}
