//
//  ArticleListViewModel.swift
//  NYTimesArticles
//
//  Created by Michal W on 12/02/2019.
//  Copyright © 2019 Michal W. All rights reserved.
//

import Foundation


protocol ArticleListViewModelDelegate: class {
//    func reposViewModel(_ reposViewModel: ReposViewModel,
//                        isLoading: Bool)
//    func reposViewModel(_ reposViewModel: ReposViewModel,
//                        didSelectId id: Int)
    func articleListViewModel(_ articleViewModel: ArticleListViewModel, didReceiveArticles articles: [ArticleViewModel])
    // TODO: Add fail to receive Articles
}

final class ArticleListViewModel {
    weak var delegate: ArticleListViewModelDelegate?
    
    private let networkingApi: NetworkingService
    
    private var articles: [Article]?
    
    
    init(networkingAPI: NetworkingService) {
        self.networkingApi = networkingAPI
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        
    }
    
    func ready() {
        networkingApi.mostViewedArticles { [weak self] articles in
            
            guard let strongSelf = self else { return }
            
            strongSelf.articles = articles
            let articleViewModels = articles.map { ArticleViewModel(article: $0) }
            strongSelf.delegate?.articleListViewModel(strongSelf, didReceiveArticles: articleViewModels)
        }
    }
}


struct ArticleViewModel {
    let title: String
    let writtenBy: String
}

extension ArticleViewModel {
    init(article: Article) {
        self.title = article.title
        self.writtenBy = article.byline
    }
}
