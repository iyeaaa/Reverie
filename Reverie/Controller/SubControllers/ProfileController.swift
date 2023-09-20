//
//  ProfileController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/06.
//

import UIKit
import Firebase

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User
    
    var thinks = [Think]()
    
    // MARK: - Lifecycle
    
    // User 초기화 시작
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Configures
    
    func configure() {
        configureColletionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchThinks()
    }
    
    func configureColletionView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapLogoutButton))
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
    }
    
    // MARK: - Actions
    
    @objc func didTapLogoutButton() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        let maintabController = tabBarController as! MainTabController
        maintabController.checkIfUserIsLoggedIn()
    }
    
    // MARK: - API
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: self.user.uid) { userStats in
            self.user.stats = userStats
            self.collectionView.reloadData()
        }
    }
    
    func fetchThinks() {
        ThinkService.fetchThinks(forUser: user.uid) { thinks in
            self.thinks = thinks
            self.collectionView.reloadData()
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thinks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = ThinkCellViewModel(think: thinks[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        
        // 원래 header를 여기서 직접 수정할 수 있지만!
        // view의 수정은 최대한 view 자체에서 이루어지도록 하기위함
        header.viewModel = ProfileHeaderViewModel(user: user)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
//        controller.post = thinks[indexPath.row]
//        navigationController?.pushViewController(controller, animated: true) // 어떻게 되는거지
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        if user.isCurrentUser {
            
        } else if user.isFollowed {
            UserService.unfollowUser(uid: user.uid) { error in
                if let error = error {
                    print("DEBUG: 언팔로우 과정중에 에러 생김, \(error)")
                    return
                }
                self.user.isFollowed = false
                self.collectionView.reloadData()
                
                ThinkService.updateUserThinkAfterFollowing(user: user, didFollow: false)
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                if let error = error {
                    print("DEBUG: 팔로우 과정중에 에러 생김, \(error)")
                    return
                }
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.uploadNotification(toUser: user.uid, type: .follow)
                ThinkService.updateUserThinkAfterFollowing(user: user, didFollow: true)
            }
        }
    }
}
