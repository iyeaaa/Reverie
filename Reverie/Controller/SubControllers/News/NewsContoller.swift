//
//  NewsCell.swift
//  Reverie
//
//  Created by 이예인 on 2023/08/26.
//

import UIKit
import SDWebImage
import Then

// MARK: - NewsController

class NewsContoller: UIViewController {
    // MARK: - Properties
    
    var viewModel: NewsViewModel? {
        didSet { 
            bottomSheetView.viewModel = viewModel
            configureByViewModel()
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var bottomSheetView = NewsBottomSheetView().then {
        $0.popDelegate = self
    }
    
    private lazy var imageView = UIImageView().then {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Configures
    
    func configure() {
        view.backgroundColor = .lightGray
    }

    func configureAutoLayout() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view)
        }
        
        view.addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureByViewModel() {
        imageView.sd_setImage(with: viewModel?.imageUrl) { image, _, _, _ in
            guard let image = image else { return }
            let ratio: CGFloat = image.size.width / image.size.height
            
            self.imageView.snp.makeConstraints { make in
                make.height.equalTo(self.imageView.snp.width).dividedBy(ratio)
            }
            
            self.bottomSheetView.imageHeight = self.view.frame.width / ratio - 20
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapImage() {
        if let openedImage = imageView.image {
            let controller = OpenImageController(image: openedImage)
            navigationController?.pushViewController(controller, animated: false)
        }
    }
}

// MARK: - NewsBottomSheetViewDelegate

extension NewsContoller: NewsBottomSheetViewDelegate {
    func popNavgationPage() {
        navigationController?.popViewController(animated: true)
    }
}
