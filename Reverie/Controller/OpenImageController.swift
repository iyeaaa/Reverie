//
//  OpenImageController.swift
//  Reverie
//
//  Created by 이예인 on 9/6/23.
//

import UIKit

class OpenImageController: UIViewController {
    
    private lazy var scrollView = UIScrollView().then {
        $0.delegate = self
        $0.zoomScale = 1.0
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 3.0
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = true
    }
    
    private lazy var imageView = UIImageView()
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "image"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(didTapXButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.down.app"),
            style: .plain,
            target: self,
            action: #selector(didTapDownloadButton)
        )
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.size.equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func didTapXButton() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func didTapDownloadButton() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func imageSaved(image:UIImage,didFinishSavingWithError error:Error,contextInfo:UnsafeMutableRawPointer?){
        let alert = UIAlertController(
            title: "Image saved to Photos!",
            message: nil,
            preferredStyle: .alert
        )
        let closeAction = UIAlertAction(title: "close", style: .cancel)
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
}

extension OpenImageController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
