//
//  NewsDB.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation
import RealmSwift

class NewsRealmObject: Object {
    @Persisted var title: String = ""
    @Persisted(primaryKey: true) var url: String = ""
    @Persisted var urlToImage: String = ""
    @Persisted var publishedAt: String = ""
    @Persisted var haveRead: Bool = false
    
    convenience init(news: News) {
        self.init()
        self.title = news.title
        self.url = news.url
        self.urlToImage = news.urlToImage ?? ""
        self.publishedAt = news.publishedAt
    }
}


// MARK: - RealmManager CRUD

extension RealmManager {
    
    @discardableResult
    func add(news: News) -> NewsRealmObject {
        if let existNewsObject = self.getNews(by: news.url) {
            return existNewsObject
        }
        
        let newsObject = NewsRealmObject(news: news)
        let realm = try! Realm()
        try! realm.write {
            realm.add(newsObject)
        }
        
        return newsObject
    }
    
    func getNews(by urlString: String) -> NewsRealmObject? {
        let realm = try! Realm()
        let newsObjects = realm.objects(NewsRealmObject.self)
        
        return newsObjects.where {
            $0.url == urlString
        }.first
    }
    
    func haveRead(urlString: String) {
        guard let newsObject = self.getNews(by: urlString) else { return }
        
        let realm = try! Realm()
        try! realm.write {
            newsObject.haveRead = true
        }
    }
    
    func newsList() -> [NewsRealmObject] {
        let realm = try! Realm()
        return Array(realm.objects(NewsRealmObject.self))
    }
}
