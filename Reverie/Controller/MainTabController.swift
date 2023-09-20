//
//  MainTabController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/06.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    private var user: User? {
        // 유저 정보가 불러와 졌다면 viewControllers 설정한다.
        didSet {
            guard let user = user else { return }
            thumbnailImage.isHidden = true
            tabBar.isHidden = false
            configureViewController(withUser: user)
        }
    }
    
    // MARK: - UI Properties
    
    private var thumbnailImage = UIImageView().then {
        $0.image = UIImage(named: "LaunchImage")
        $0.contentMode = .scaleAspectFill
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(thumbnailImage)
        thumbnailImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 로그인 되었는지 확인한 후 안되었다면 로그인 화면 present한다.
        checkIfUserIsLoggedIn()
        
        // 유저 정보 불러온다.
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBar.isHidden = true
    }

    // MARK: - Configures
    
    func configureViewController(withUser user: User) {
        
        /* navigationContoller로 씌우고 tabbar 아이템 지정후 내보낸다 */
        func templateNavigationController(unselectedImage: UIImage, seletedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.tabBarItem.image = unselectedImage
            nav.tabBarItem.selectedImage = seletedImage
            nav.tabBarItem.title = nil
            return nav
        }
        
        view.backgroundColor = .white
        self.delegate = self
        
        let feed = templateNavigationController(
            unselectedImage: UIImage(systemName: "house")!,
            seletedImage: UIImage(systemName: "house.fill")!,
            rootViewController: HomePageController()
        )
        
        let search = templateNavigationController(
            unselectedImage: UIImage(systemName: "magnifyingglass.circle")!,
            seletedImage: UIImage(systemName: "magnifyingglass.circle.fill")!,
            rootViewController: SearchController()
        )
        
        let imageSelector = templateNavigationController(
            unselectedImage: UIImage(systemName: "pencil.and.outline")!,
            seletedImage: UIImage(systemName: "pencil.and.outline")!,
            rootViewController: ImageSelectorController()
        )
        
        let nofitications = templateNavigationController(
            unselectedImage: UIImage(systemName: "heart")!,
            seletedImage: UIImage(systemName: "heart.fill")!,
            rootViewController: NotificationController()
        )
        
        let profile = templateNavigationController(
            unselectedImage: UIImage(systemName: "person")!,
            seletedImage: UIImage(systemName: "person.fill")!,
            rootViewController: ProfileController(user: user)
        )
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
            
        viewControllers = [feed, search, imageSelector, nofitications, profile]
    }
    
    // MARK: - API
    
    func fetchUser() {
        UserService.fetchCurrentUser { user in
            self.user = user
            self.navigationItem.title = user.username
        }
    }
    
    func checkIfUserIsLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            
            // 로그인 정보가 없다면!
            if user == nil {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false)
            }
            
        }
    }
    
    // MARK: - Helpers
    
    /* 사진 선택 끝나고 실행될 함수 */
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in 
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadThinkController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: false)
            }
        }
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    /* 로그인 정보가 없어서 다시 로그인, 회원가입 했을 때 실행될 메소드 */
    func authenticationDidComplete() {
        fetchUser()
        dismiss(animated: true)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            
            config.isScrollToChangeModesEnabled = true
            config.showsPhotoFilters = true
            config.showsVideoTrimmer = true
            config.albumName = "DefaultYPImagePickerAlbumName"
            config.screens = [.library]
            config.targetImageSize = YPImageSize.original
            config.overlayView = UIView()
            config.hidesStatusBar = true
            config.hidesBottomBar = false
            config.hidesCancelButton = false
            config.preferredStatusBarStyle = UIStatusBarStyle.default
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishPickingMedia(picker)
        }
        
        return true
    }
}

// MARK: - UploadPostControllerDelegate

extension MainTabController: UploadThinkControllerDelegate {
    func contollerDidFinishuploadingThink(_ contoller: UploadThinkController) {
        selectedIndex = 0
        contoller.dismiss(animated: true)
        fetchUser()
    }
}
