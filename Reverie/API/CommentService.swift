//
//  CommentService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/18.
//

import Firebase

struct CommentService {
    
    /*
     인터페이스만 보고 필요한 요소를 생각하면
     프로필 이미지, username, commment면 충분하다.
     시간을 표시하고 정렬해야하므로 timestamp가 필요하겠다.
     
     근데 user uid가 왜 필요할까?? -> 클릭했을 때 Profile로 이동하려고
     */
    
    static func uploadComment(comment: String, thinkID: String, user: User, completion: @escaping FirestoreCompletion) {
        let data: [String: Any] = ["ownerImageURL": user.profileImageUrl,
                                   "ownerUserName": user.username,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "uid": user.uid]
        
        COLLECTION_THINKS.document(thinkID).collection("comment").addDocument(data: data, completion: completion)
    }
    
    static func fetchComment(thinkID: String, completion: @escaping ([Comment]) -> Void) {
        var comments = [Comment]()
        COLLECTION_THINKS.document(thinkID).collection("comment").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            for diff in snapshot.documentChanges where diff.type == .added {
                comments.append(Comment(dictionary: diff.document.data()))
            }
            completion(comments.sorted { $0.timestamp.seconds < $1.timestamp.seconds })
        }
    }
}
