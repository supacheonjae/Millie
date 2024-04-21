//
//  TopHeadlinesRestAPI.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class TopHeadlinesRestAPI: TopHeadlinesService {
    
    private let topHeadlinesURLString = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=fd9a870a45494c298d147552861aac31"
    
    
    func fetchTopHeadlines() -> Single<NewsResponse> {
        return Session.default.rx
            .responseData(.get, topHeadlinesURLString)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { response, data -> Observable<NewsResponse> in
                switch response.statusCode {
                case 200:
                    let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                    return .just(result)
                default:
                    return .error(NSError(domain: "", code: -1))
                }
            }
            .asSingle()
    }
}
