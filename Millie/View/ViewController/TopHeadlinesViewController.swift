//
//  TopHeadlinesViewController.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/20.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage

final class TopHeadlinesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let fetchTopHeadlines: PublishRelay<Void> = PublishRelay()
    private let selectTopHeadline: PublishRelay<NewsRealmObject> = PublishRelay()
    private let disposeBag = DisposeBag()
    private var viewModel: TopHeadlinesViewModel!
    
    private var topHeadlines: [NewsRealmObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "탑 헤드라인"
        
        self.collectionView.register(UINib(nibName: "TopHeadlineCell", bundle: nil), forCellWithReuseIdentifier: "TopHeadlineCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.bindViewModel()
        self.fetchTopHeadlines.accept(())
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    /// ViewModel 바인딩
    private func bindViewModel() {
        let services = NewsServices(topHeadlinesService: TopHeadlinesRestAPI())
        self.viewModel = TopHeadlinesViewModel(services: services)
        
        let input = TopHeadlinesViewModel.Input(
            fetchTopHeadlines: self.fetchTopHeadlines,
            selectTopHeadline: self.selectTopHeadline
        )
        let output = viewModel.transform(input: input)
        
        output.topHeadlines
            .withUnretained(self)
            .drive(onNext: { owner, topHeadlines in
                owner.topHeadlines = topHeadlines
                owner.collectionView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
}


// MARK: - UICollectionViewDataSource

extension TopHeadlinesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topHeadlines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopHeadlineCell", for: indexPath) as! TopHeadlineCell
        let newsObject = self.topHeadlines[indexPath.item]
        cell.titleLabel.text = newsObject.title
        cell.titleLabel.textColor = newsObject.haveRead ? .red : .black
        cell.publishedAtLabel.text = newsObject.publishedAt
        
        if newsObject.urlToImage.isEmpty == false {
            if let image = ImageLoader.shared.getLocalImage(newsURLString: newsObject.url) {
                cell.thumbnailImageView.image = image
                
            } else {
                AF.request(newsObject.urlToImage)
                    .responseImage { response in
                        if case .success(let image) = response.result {
                            cell.thumbnailImageView.image = image
                            ImageLoader.shared.saveImage(image: image, newsURLString: newsObject.url)
                        } else {
                            cell.thumbnailImageView.image = nil
                        }
                    }
            }
        }
        
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension TopHeadlinesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        var size = CGSize()
        if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            let itemWidth = collectionView.bounds.size.width / 3 - flowLayout.minimumInteritemSpacing
            let itemHeight: CGFloat = 120
            size = CGSize(width: itemWidth, height: itemHeight)
            
        } else if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
            if collectionView.bounds.width < collectionView.bounds.height {
                let itemWidth = collectionView.bounds.size.width
                let itemHeight: CGFloat = 120
                size = CGSize(width: itemWidth, height: itemHeight)
            } else {
                let itemWidth = collectionView.bounds.size.width / 3 - flowLayout.minimumInteritemSpacing
                let itemHeight: CGFloat = 120
                size = CGSize(width: itemWidth, height: itemHeight)
            }
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let newsWebViewController = self.storyboard?.instantiateViewController(identifier: "NewsWebViewController") as? NewsWebViewController else {
            return
        }
        
        let news = self.topHeadlines[indexPath.item]
        self.selectTopHeadline.accept(news)
        newsWebViewController.news = news
        self.navigationController?.pushViewController(newsWebViewController, animated: true)
    }
}
