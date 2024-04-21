//
//  NewsServices.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation

final class NewsServices: HasTopHeadlinesService {
    
    let topHeadlinesService: TopHeadlinesService
    
    
    init(topHeadlinesService: TopHeadlinesService) {
        self.topHeadlinesService = topHeadlinesService
    }
}
