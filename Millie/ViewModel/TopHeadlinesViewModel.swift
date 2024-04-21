//
//  TopHeadlinesViewModel.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation
import RxSwift
import RxCocoa

final class TopHeadlinesViewModel: ServicesViewModel {
    
    struct Input {
        let fetchTopHeadlines: PublishRelay<Void>
        let selectTopHeadline: PublishRelay<NewsRealmObject>
    }
    
    struct Output {
        let topHeadlines: Driver<[NewsRealmObject]>
    }
    
    
    var services: NewsServices
    
    private let topHeadlines = PublishRelay<[NewsRealmObject]>()
    private let disposeBag = DisposeBag()
    private var fetchTopHeadlinesDisposeBag = DisposeBag()
    
    
    init(services: NewsServices) {
        self.services = services
    }
    
    func transform(input: Input) -> Output {
        input.fetchTopHeadlines
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetchTopHeadlines()
            })
            .disposed(by: self.disposeBag)
        
        input.selectTopHeadline
            .subscribe(onNext: { [weak self] news in
                RealmManager.shared.haveRead(urlString: news.url)
                let newsList = RealmManager.shared.newsList()
                self?.topHeadlines.accept(newsList)
            })
            .disposed(by: self.disposeBag)
        
        return Output(topHeadlines: self.topHeadlines.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func fetchTopHeadlines() {
        self.fetchTopHeadlinesDisposeBag = DisposeBag()
        
        self.services.topHeadlinesService.fetchTopHeadlines()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                onSuccess: { [weak self] newsResponse in
                    var newsList: [NewsRealmObject] = []
                    for news in newsResponse.articles {
                        if let newsObject = RealmManager.shared.getNews(by: news.url) {
                            newsList.append(newsObject)
                        } else {
                            let newsObject = RealmManager.shared.add(news: news)
                            newsList.append(newsObject)
                        }
                    }
                    self?.topHeadlines.accept(newsList)
                },
                onFailure: { [weak self] error in
                    print(error.localizedDescription)
                    let newsList = RealmManager.shared.newsList()
                    self?.topHeadlines.accept(newsList)
                }
            )
            .disposed(by: self.fetchTopHeadlinesDisposeBag)
    }
}
