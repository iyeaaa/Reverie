//
//  PostController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/23.
//

import UIKit
import Toast
import Then

private let newsPageCellIdentifier = "newsPageCellIdentifier"
private let feedCellIdentifier = "feedCellIdentifier"

class NewsListController: UIViewController {
    
    // MARK: - Properties
    
    var initCategory: String
    
    // MARK: - UI Properties
    
    private lazy var newsListView = NewsListView(currentCategory: initCategory).then {
        $0.messageDelegate = self
        $0.openNewsDelegate = self
    }
    
    // MARK: - Lifecycle
    
    init(initCategory: String) {
        self.initCategory = initCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Configures
    
    func configure() {
//        for family in UIFont.familyNames {
//
//                    let sName: String = family as String
//                    print("family: \(sName)")
//
//                    for name in UIFont.fontNames(forFamilyName: sName) {
//                        print("name: \(name as String)")
//                    }
//                }
    }
    
    func configureAutoLayout() {
        view.addSubview(newsListView)
        newsListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - NewsPageCellMessageDelegate {

extension NewsListController: NewsPageCellMessageDelegate {
    func showMessage(_ message: String) {
        let toast = Toast.default(
            image: UIImage(systemName: "xmark.circle"),
            title: message,
            subtitle: nil
        )
        toast.show()
    }
}

// MARK: - NewsPageCellOpenDelegate

extension NewsListController: NewsPageCellOpenDelegate {
    func openNews(news: News) {
        let controller = NewsContoller().then {
            $0.viewModel = NewsViewModel(news: news)
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}
