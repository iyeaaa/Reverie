//
//  FeedController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/06.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommunityCell"

class CommunityView: UIView {
    // MARK: - Properties
    
    var thinks = [Think]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
    
    var think: Think?
    
    // MARK: - UI Properties
    
    private lazy var collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: fl)
        cv.backgroundColor = .white
        cv.register(ThinkCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
//    @objc func handleLogout() {
//        do {
//            try Auth.auth().signOut()
//            let controller = LoginController()
//
//            controller.delegate = self.tabBarController as? MainTabController
//
//            let nav = UINavigationController(rootViewController: controller)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true)
//        } catch {
//            print("Fail to sign out")
//        }
//    }
    
    @objc func handleRefresh() {
        fetchFeeds()
    }
    
    // MARK: - API
    
    func fetchFeeds() {
        guard think == nil else { return }
        ThinkService.fetchFollowingThink { thinks in
            self.thinks = thinks
        }
    }
    
    // MARK: - Configures
    
    func configure() {
        // collectionView 설정
        
        
//        if post == nil {
//            // logout 버튼 설정
//            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
//            navigationItem.leftBarButtonItem?.tintColor = .black
//            navigationItem.title = "Feed"
//        } else {
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: nil)
//        }
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
        fetchFeeds()
    }
    
    func configureAutoLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CommunityView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return think == nil ? thinks.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ThinkCell
        cell.viewModel = ThinkCellViewModel(think: think ?? thinks[indexPath.row])
//        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
 
extension CommunityView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = frame.width
        var height = 8 + 40 + 8 + width
        height += 110
        height += 20
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate

//extension CommunityView: FeedCellDelegate {
//
//    /* Comment창 열어줌 */
//    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
//        let controller = CommentController(post: post)
//        navigationController?.pushViewController(controller, animated: true)
//    }
//
//    /* 좋아요 버튼 눌렀을 때 실행할것 */
//    func cell(_ cell: FeedCell, didLike post: Post) {
//
//        if !post.didLike {
//            PostService.likePost(post: post) { error in
//                if let error = error {
//                    print("error during like post: \(error)")
//                }
//                cell.tapLikeButton()
//                NotificationService.uploadNotification(toUser: post.ownerUid, type: .like, post: post)
//            }
//        } else {
//            PostService.unlikePost(post: post) { error in
//                if let error = error {
//                    print("error during unlike post: \(error)")
//                }
//                cell.tapUnlikeButton()
//            }
//        }
//
//        post.didLike.toggle()
//    }
//
//    func cell(_ cell: FeedCell, didTapUsername uid: String) {
//        UserService.fetchUser(withUID: uid) { user in
//            let controller = ProfileController(user: user)
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//    }
//
//}
