//
//  NotificationCellViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/20.
//

import UIKit

struct NotificationCellViewModel {
    var notification: Notification
    
    var profileImageURL: URL? {
        URL(string: notification.profileImageURL)
    }
    
    var thinkImageURL: URL? {
        URL(string: notification.thinkImageURL ?? "")
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date())
    }
    
    var infomation: NSMutableAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSMutableAttributedString(string: "   \(timestampString ?? "2m")", attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        return attributedText
    }
    
    var shouldHideThinkImage: Bool {
        notification.type == .follow
    }
    
    var followButtonText: String { return notification.userIsFollowd ? "Following" : "Follow" }
    
    var followButtonBackgroundColor: UIColor { return notification.userIsFollowd ? .white : .systemBlue }
    
    var followButtonTintColor: UIColor { return notification.userIsFollowd ? .black : .white }
    
    init(notification: Notification) {
        self.notification = notification
    }
}
