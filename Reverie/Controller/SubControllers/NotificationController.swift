//
//  NotificationController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/06.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    // MARK: - Properties
    
    var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    private let refresher = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        fetchNotifications()
        refresher.endRefreshing()
    }
    
    // MARK: - Helpers
    
    func fetchNotifications() {
        NotificationService.fetchNotification { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
        }
    }
    
    func checkIfUserIsFollowed() {
        for (index, notification) in notifications.enumerated() where notification.type == .follow {
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                self.notifications[index].userIsFollowd = isFollowed
            }
        }
    }
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
}

// MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationCellViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        UserService.fetchUser(withUID: notifications[indexPath.row].uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        showLoader(true)
        UserService.follow(uid: uid) { error in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowd.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToUnFollow uid: String) {
        showLoader(true)
        UserService.unfollowUser(uid: uid) { error in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowd.toggle()
        }
    }

    func cell(_ cell: NotificationCell, wantsToViewThink thinkID: String) {
        showLoader(true)
        ThinkService.fetchThink(forThink: thinkID) { think in
//            self.showLoader(false)
////            let contoller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
////            contoller.post = post
//            self.navigationController?.pushViewController(contoller, animated: true)
        }
    }
}
