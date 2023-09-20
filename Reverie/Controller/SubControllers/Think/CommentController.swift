//
//  CommentController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/16.
//

import UIKit

private let reuseIdentifer = "CommentCell"

class CommentController: UICollectionViewController {
    // MARK: - properties
    
    private let think: Think
    
    private var comments = [Comment]()
    
    // viewDidLoad같은 곳에서 적어야할걸 클로저를 통해 더 직관적으로 적을 수 있다고 생각하자.
    // 때문에 delegate = self도 여기서 적으면 좋다
    private lazy var commentInputView: CommentInputAccessoryView = {
        let cv = CommentInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: 50))
        cv.delegate = self
        return cv
    }()
    
    // MARK: - lifecycle
    
    init(think: Think) {
        self.think = think
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }

    override var inputAccessoryView: UIView? {
        return commentInputView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = "Comments"
        
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        collectionView.alwaysBounceVertical = true // 셀이 화면 크기보다 적더라도, 스크롤 효과 생김
        collectionView.keyboardDismissMode = .interactive // 콜렉션 뷰 내리면서 키보드 같이 내릴 수 있게됨
    }
    
    func fetchComments() {
        showLoader(true)
        CommentService.fetchComment(thinkID: think.thinkID) { comments in
            self.comments = comments
            self.collectionView.reloadData()
            self.showLoader(false)
        }
    }
    
    func optimalSize(text: String) -> CGSize {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        let width = view.frame.width
        let height = max(60, label.frame.height + 20)
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(withUID: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UIColletionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let width = view.frame.width
        let height = max(60, viewModel.calculateHeight(forWidth: view.frame.width - 70) + 20) // 프로필 사진보다는 높이가 커야하므로 프로필 사진높이(40) + 20
        return CGSize(width: width, height: height)
    }
}

// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CommentInputAccessoryViewDelegate {
    
    // 우선, post 정보를 가져오기 위해 이니셜라이저를 이용할 것 같은데 어떻게 처리함이 좋을까?
    // 강사도 같은 생각을 했다..!
    
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        showLoader(true)
        CommentService.uploadComment(comment: comment, thinkID: think.thinkID, user: UserService.currentLoginUser!) { error in
            if let error = error {
                print("error during comment upload: \(error)")
            }
            self.fetchComments()
            self.showLoader(false)
            
            NotificationService.uploadNotification(toUser: self.think.ownerUid, type: .comment, think: self.think)
        }
    }
}
