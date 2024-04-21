//
//  TopHeadlinesService.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation
import RxSwift

protocol HasTopHeadlinesService {
    var topHeadlinesService: TopHeadlinesService { get }
}

protocol TopHeadlinesService {
    func fetchTopHeadlines() -> Single<NewsResponse>
}
