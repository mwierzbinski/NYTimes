//
//  ViewController.swift
//  NYTimesArticles
//
//  Created by Michal W on 11/02/2019.
//  Copyright © 2019 Michal W. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController {

    private let viewModel: ArticleListViewModel
    private var data: [ArticleViewModel]?

// Init
    init(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ArticleListViewModel(networkingAPI: NetworkingAPI())
        super.init(coder: aDecoder)
    }

// Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.ready()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
}

//UITableViewDataSource
extension ArticleListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let data = data else { return ArticleListTableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleListTableViewIdentifier", for: indexPath) as! ArticleListTableViewCell
        
        let articleViewModel = data[indexPath.row]
        cell.title.text = articleViewModel.title
        cell.writtenBy.text = "some text"
        
        return cell
    }
}

//UITableViewDelegate
extension ArticleListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension ArticleListTableViewController : ArticleListViewModelDelegate {
    func articleListViewModel(_ articleViewModel: ArticleListViewModel, didReceiveArticles articles: [ArticleViewModel]) {
        data = articles
        tableView.reloadData()
    }
}


