//
//  MainPageContoller.swift
//  Reverie
//
//  Created by 이예인 on 2023/09/02.
//

import UIKit

struct HomeCategory {
    let name: String
    let image: UIImage
}

class HomePageController: UIViewController {
    
    // MARK: - Properties
    
    var cacheViewModels = [
        "",
        "General",
        "Business",
        "Entertainment",
        "Health",
        "Science",
        "Sports",
        "Technology",
    ]
        .enumerated()
        .map { index, categoryName in
            HomeCategoryTableCellViewModel(newsList: nil,
                                           category: categoryName,
                                           collectionViewPageIndex: 0,
                                           index: index)
        }
    
    // MARK: - UI Properties
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.delegate = self
        $0.dataSource = self
        $0.register(HomeThinkCollectionCell.self, forCellReuseIdentifier: HomeThinkCollectionCell.id)
        $0.register(HomeCategoryTableCell.self, forCellReuseIdentifier: HomeCategoryTableCell.id)
        $0.separatorStyle = .none
        $0.contentInset.bottom = 30
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    
    }
    
    // MARK: - Configures
    
    func configure() {
        navigationItem.title = "Reverie"
        tableView.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .white
    }
    
    func configureAutoLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Helpers
    
    
}

// MARK: - TableView DataSource

extension HomePageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeThinkCollectionCell.id,
                for: indexPath
            ) as! HomeThinkCollectionCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HomeCategoryTableCell.id,
                for: indexPath
            ) as! HomeCategoryTableCell
            cell.delegate = self
            cell.viewModel = cacheViewModels[indexPath.item]
            return cell
        }
    }
}

// MARK: - TableView Delegate

extension HomePageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - HomeCategoryTableCell Delegate

extension HomePageController: HomeCategoryTableCellDelegate {
    func openNews(news: News) {
        let controller = NewsContoller()
        controller.viewModel = NewsViewModel(news: news)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openNewsList(category: String?) {
        guard let category = category else { return }
        let contoller = NewsListController(initCategory: category)
        navigationController?.pushViewController(contoller, animated: true)
    }
    
    func saveViewModelData(viewModel: HomeCategoryTableCellViewModel) {
        cacheViewModels[viewModel.index] = viewModel
    }
    
    func updateCurrentPage(viewModel: HomeCategoryTableCellViewModel, page: Int) {
        cacheViewModels[viewModel.index].collectionViewPageIndex = page
    }
}
