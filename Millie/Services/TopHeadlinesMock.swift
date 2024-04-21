//
//  TopHeadlinesMock.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation
import RxSwift

final class TopHeadlinesMock: TopHeadlinesService {
    
    func fetchTopHeadlines() -> Single<NewsResponse> {
        return Single.create { observer in
            let url = Bundle.main.url(
                forResource: "top-headlines",
                withExtension: "json"
            )
            
            if let data = try? Data(contentsOf: url!) {
                let newsResponse = try! JSONDecoder().decode(NewsResponse.self, from: data)
                observer(.success(newsResponse))
            } else {
                observer(.failure(NSError(domain: "", code: 1)))
            }
            
            return Disposables.create()
        }
    }
}

