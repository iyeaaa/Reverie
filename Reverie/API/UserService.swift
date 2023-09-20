//
//  UserService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/11.
//

// 유저, 팔로우 정보 fetch

import Firebase

typealias FirestoreCompletion = (Error?) -> Void


struct UserService {
    private static let followingCollectionName = "user-following"
    private static let followerCollectionName = "user-followers"
    
    static var currentLoginUser: User?
    
    // MARK: - USER
    static func fetchCurrentUser(completion: ((User) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            let user = User(dictionary: dictionary)
            currentLoginUser = user
            
            guard let completion = completion else { return }
            completion(user)
        }
    }
    
    static func fetchUser(withUID uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.map{ User(dictionary: $0.data()) }
            completion(users)
        }
    }
    
    // MARK: - FOLLOW
    
    static func follow(uid: String, completion: @escaping FirestoreCompletion) {
        guard let currentUid = currentLoginUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection(followingCollectionName).document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection(followerCollectionName).document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollowUser(uid: String, completion: @escaping FirestoreCompletion) {
        guard let currentUid = currentLoginUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection(followingCollectionName).document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection(followerCollectionName).document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = currentLoginUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection(followingCollectionName).document(uid).getDocument { document, error in
            completion(document != nil && document!.exists)
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping (UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection(followerCollectionName).getDocuments { followerDocument, _ in
            COLLECTION_FOLLOWING.document(uid).collection(followingCollectionName).getDocuments { followingDocument, _ in
                COLLECTION_THINKS.whereField("ownerUid", isEqualTo: uid).getDocuments { thinks, _ in
                    guard let follower = followerDocument?.count,
                          let following = followingDocument?.count,
                          let think = thinks?.count else { return }
                    
                    let userStats = UserStats(thinks: think, followers: follower, following: following)
                    completion(userStats)
                }
            }
        }
    }
}


