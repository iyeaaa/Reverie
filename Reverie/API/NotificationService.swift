//
//  NotificationService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/20.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUser uid: String, type: NotificationType, think: Think? = nil) {
        guard let currentUser = UserService.currentLoginUser else { return }
        guard currentUser.uid != uid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification").document()
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": currentUser.uid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "profileImageURL": currentUser.profileImageUrl,
                                   "username": currentUser.username]
        
        if let think = think {
            data["postID"] = think.thinkID
            data["postImageURL"] = think.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotification(completion: @escaping ([Notification]) -> Void) {
        guard let uid = UserService.currentLoginUser?.uid else { return }
        
        let query = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification").order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let notifications = documents.map{ Notification(dictionary: $0.data()) }
            completion(notifications)
        }
    }
}
