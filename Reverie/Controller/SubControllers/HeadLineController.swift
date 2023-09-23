//
//  MainPageContoller.swift
//  Reverie
//
//  Created by 이예인 on 2023/09/02.
//

import UIKit

struct HeadLineCategory {
    let name: String
    let image: UIImage
}

class HeadLineController: UIViewController {
    
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
        $0.register(HeadLineThinkCollectionCell.self, forCellReuseIdentifier: HeadLineThinkCollectionCell.id)
        $0.register(HeadLineCategoryTableCell.self, forCellReuseIdentifier: HeadLineCategoryTableCell.id)
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
        navigationItem.title = "Top Headline"
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

extension HeadLineController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HeadLineThinkCollectionCell.id,
                for: indexPath
            ) as! HeadLineThinkCollectionCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HeadLineCategoryTableCell.id,
                for: indexPath
            ) as! HeadLineCategoryTableCell
            cell.delegate = self
            cell.viewModel = cacheViewModels[indexPath.item]
            return cell
        }
    }
}

// MARK: - TableView Delegate

extension HeadLineController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - HomeCategoryTableCell Delegate

extension HeadLineController: HeadLineCategoryTableCellDelegate {
    func openNews(news: News) {
        let controller = NewsContoller()
        controller.viewModel = NewsViewModel(news: news)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openNewsList(category: String?) {
        guard let category = category else { return }
        let contoller = NewsListController(initCategory: category, headline: true)
        contoller.modalPresentationStyle = .fullScreen
        contoller.delegate = self
        present(contoller, animated: true)
    }
    
    func saveViewModelData(viewModel: HomeCategoryTableCellViewModel) {
        cacheViewModels[viewModel.index] = viewModel
    }
    
    func updateCurrentPage(viewModel: HomeCategoryTableCellViewModel, page: Int) {
        cacheViewModels[viewModel.index].collectionViewPageIndex = page
    }
}

// MARK: - NewsListContollerDelegate

extension HeadLineController: NewsListControllerDelegate {
    func controllerAppearTabbar(_ controller: NewsListController) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
