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

protocol NewsListControllerDelegate: AnyObject {
    func controllerAppearTabbar(_ controller: NewsListController)
}

final class NewsListController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: NewsListControllerDelegate?
    
    var initCategory: String
    
    var headline: Bool = false
    
    // MARK: - UI Properties
    
//    private var exitButtonConfiguration: UIButton.Configuration = {
//        var confi = UIButton.Configuration.gray()
////        confi.background.cornerRadius =
//        confi.image =
//        confi.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//        return confi
//    }()
    
    private lazy var exitButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 30)), for: .normal)
        $0.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        $0.tintColor = .lightGray.withAlphaComponent(0.7)
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
        $0.isHidden = !headline
    }
    
    private lazy var newsListView = NewsListView(
        currentCategory: initCategory,
        containsCategory: headline
    ).then {
        $0.messageDelegate = self
        $0.openNewsDelegate = self
    }
    
    // MARK: - Lifecycle
    
    init(initCategory: String, headline: Bool) {
        self.initCategory = initCategory
        self.headline = headline
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
        navigationItem.title = "Latest News"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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
        
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapExitButton() {
        self.dismiss(animated: true) {
            self.delegate?.controllerAppearTabbar(self)
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
