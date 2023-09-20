//
//  PostService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/15.
//

import UIKit
import Firebase

struct ThinkService {
    
    // MARK: - Post
    
    static func uploadThink(caption: String, image: UIImage, completion: @escaping FirestoreCompletion) {
        guard let user = UserService.currentLoginUser else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data: [String: Any] = ["caption": caption,
                                       "timestamp": Timestamp(date: Date()),
                                       "imageUrl": imageUrl,
                                       "ownerUid": user.uid,
                                       "likes": 0,
                                       "ownerImageUrl": user.profileImageUrl,
                                       "ownerUsername": user.username]
            
            
            let docRef = COLLECTION_THINKS.addDocument(data: data, completion: completion)
            updateUserThinkAfterUpload(thinkID: docRef.documentID)
        }
    }
    
    static func fetchThink(forThink thinkID: String, completion: @escaping (Think) -> Void) {
        COLLECTION_THINKS.document(thinkID).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            let think = Think(thinkID: thinkID, dictionary: data)
            completion(think)
//            checkLikeThink(thinkID: thinkID, uid: uid) { didLike in
//                think.didLike = didLike
//                completion(think)
//            }
        }
    }
    
    static func fetchThinks(completion: @escaping ([Think]) -> Void) {
        var thinks = [Think]()
        
        COLLECTION_THINKS.getDocuments { snapshot, error in
            var thinks = [Think]()
            snapshot?.documents.forEach{ document in
                thinks.append(Think(thinkID: document.documentID, dictionary: document.data()))
            }
            completion(thinks)
        }
    }
    
    static func fetchThinks(forUser uid: String, completion: @escaping ([Think]) -> Void) {
        guard let currentUID = UserService.currentLoginUser?.uid else { return }
        
        let query = COLLECTION_THINKS.whereField("ownerUid", isEqualTo: uid)
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let dispatchGroup = DispatchGroup()
            let thinks = documents.map({ Think(thinkID: $0.documentID, dictionary: $0.data()) })
            
            for think in thinks {
                dispatchGroup.enter()
                checkLikeThink(thinkID: think.thinkID, uid: currentUID) { didLike in
                    think.didLike = didLike
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(thinks.sorted{$0.timestamp.seconds < $1.timestamp.seconds})
            }
        }
    }

    // 팔로잉한 사용자의 모든 post를 가져온다.
    static func fetchFollowingThink(completion: @escaping ([Think]) -> Void) {
        guard let uid = UserService.currentLoginUser?.uid else { return }
        var thinks = [Think]()
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            let dispatchGroup = DispatchGroup()
            
            snapshot?.documents.forEach { document in
                dispatchGroup.enter()
                fetchThink(forThink: document.documentID) { think in
                    thinks.append(think)
                    dispatchGroup.leave()
                    print(thinks.count)
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                print(thinks)
                completion(thinks.sorted{$0.timestamp.seconds > $1.timestamp.seconds})
            }
        }
    }
    
    // MARK: - LIKE
    
    // 유저가 포스트에 좋아요 눌렀는지 확인한다.
    private static func checkLikeThink(thinkID: String, uid: String, completion: @escaping (Bool) -> Void) {
        COLLECTION_THINKS.document(thinkID).collection("post-likes").document(uid).getDocument { document, _ in
            completion(document != nil && document!.exists)
        }
    }
    
    // 좋아요 누름
    static func likeThink(think: Think, completion: @escaping FirestoreCompletion) {
        guard let uid = UserService.currentLoginUser?.uid else { return }
        
        COLLECTION_THINKS.document(think.thinkID).updateData(["likes": think.like + 1]) { _ in
            COLLECTION_THINKS.document(think.thinkID).collection("post-likes").document(uid).setData([:]) { _ in
                COLLECTION_USERS.document(uid).collection("user-likes").document(think.thinkID).setData([:], completion: completion)
            }
        }
    }
    
    // 좋아요 취소
    static func unlikeThink(think: Think, completion: @escaping FirestoreCompletion) {
        guard let uid = UserService.currentLoginUser?.uid else { return }
        
        COLLECTION_THINKS.document(think.thinkID).updateData(["likes": think.like - 1]) { _ in
            COLLECTION_THINKS.document(think.thinkID).collection("post-likes").document(uid).delete() { _ in
                COLLECTION_USERS.document(uid).collection("user-likes").document(think.thinkID).delete(completion: completion)
            }
        }
    }
    
    // MARK: - UPDATE POST TO USER
    
    // 팔로우한 후 사용자에 포스트 추가한다
    static func updateUserThinkAfterFollowing(user: User, didFollow: Bool) {
        guard let uid = UserService.currentLoginUser?.uid else { return }
        
        let query = COLLECTION_THINKS.whereField("ownerUid", isEqualTo: user.uid)
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            for documentID in documents.map(\.documentID) {
                let path = COLLECTION_USERS.document(uid).collection("user-feed").document(documentID)
                if didFollow {
                    path.setData([:])
                } else {
                    path.delete()
                }
            }
        }
    }
    
    // 포스트 작성 후 팔로워들에게 뿌린다.
    private static func updateUserThinkAfterUpload(thinkID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            var followerUIDs = snapshot?.documents.map(\.documentID)
            followerUIDs?.append(uid)
            followerUIDs?.forEach { followerUID in
                COLLECTION_USERS.document(followerUID).collection("user-feed").document(thinkID).setData([:])
            }
        }
    }
}
