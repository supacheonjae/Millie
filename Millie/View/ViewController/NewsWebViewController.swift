//
//  NewsWebViewController.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController {

    var webView: WKWebView!
    var news: NewsRealmObject?
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = news?.title
        
        self.loadURL()
    }
    
    private func loadURL() {
        guard let urlString = self.news?.url else { return }
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        self.webView.load(request)
    }

}
