//
//  News.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation
import RealmSwift

struct NewsResponse: Codable {
    
    let totalResults: Int
    let articles: [News]
}


/// 뉴스 데이터
struct News: Codable {
    
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
}
