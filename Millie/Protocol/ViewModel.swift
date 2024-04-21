//
//  ViewModel.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

protocol ServicesViewModel: ViewModel {
    associatedtype Services
    var services: Services { get set }
}
