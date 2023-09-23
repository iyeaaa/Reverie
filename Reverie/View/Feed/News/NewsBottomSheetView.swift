//
//  NewsBottomSheetView.swift
//  Reverie
//
//  Created by 이예인 on 9/3/23.
//

import UIKit

protocol NewsBottomSheetViewDelegate: AnyObject {
    func popNavgationPage()
}

class NewsBottomSheetView: UIView {
    
    // MARK: - Properties
    
    var viewModel: NewsViewModel? {
        didSet { configureByViewModel() }
    }
    
    var imageHeight: CGFloat? {
        didSet { updateBottomSheetConstraints(imageHeight!) }
    }
    
    weak var popDelegate: NewsBottomSheetViewDelegate?
    
    // MARK: - UI Properties
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        $0.imageView?.tintColor = .white
        $0.backgroundColor = .darkGray.withAlphaComponent(0.7)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var coperationNameButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("venom", for: .normal)
        $0.titleLabel?.font = .roboto(size: 17, bold: .bold)
        $0.sizeToFit()
        $0.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
    }
    
    private lazy var exitButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .roboto(size: 20, bold: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private lazy var separateBottomLine = UIView().then {
        $0.backgroundColor = .reverie(4)
    }
    
    private let thinkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 13
        $0.clipsToBounds = true
    }
    
    private lazy var shareButton = UIButton().then {
        $0.setImage(UIImage(named: "send2"), for: .normal)
        $0.tintColor = .black
    }
    
    private lazy var scrapButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "ribbon"), for: .normal)
        $0.tintColor = .black
        
        let v = UIView()
        v.addSubview($0)
        $0.snp.makeConstraints { make in
            make.center.equalTo(v)
        }
    }
    
    private let likesLabel = UILabel().then {
        $0.text = "좋아요 1,000개"
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    private let captionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .roboto(size: 18, bold: .regular)
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
    }
    
    private let thinkTimeLabel = UILabel().then {
        $0.text = "2 days ago"
        $0.font = .roboto(size: 14, bold: .semibold)
        $0.textColor = .black
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configure() {
        backgroundColor = .clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGesture)
        
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView.layer.cornerRadius = 20
        bottomSheetView.clipsToBounds = true
    }
    
    func configureAutoLayout() {
        let commonPadding = 20
        
        addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(bottomSheetYPosition(0.3))
        }
        
        bottomSheetView.addSubview(coperationNameButton)
        coperationNameButton.snp.makeConstraints { make in
            make.top.equalTo(bottomSheetView).offset(commonPadding)
            make.centerX.equalTo(self)
        }
        
        bottomSheetView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coperationNameButton.snp.bottom).offset(15)
            make.leading.equalTo(self).offset(commonPadding)
            make.trailing.equalTo(self).offset(-commonPadding)
        }
        
        bottomSheetView.addSubview(separateBottomLine)
        separateBottomLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(commonPadding)
            make.trailing.equalTo(self).offset(-commonPadding)
            make.height.equalTo(0.7)
        }
        
        bottomSheetView.addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(separateBottomLine.snp.bottom).offset(commonPadding)
            make.leading.equalTo(self).offset(commonPadding)
            make.trailing.equalTo(self).offset(-commonPadding)
        }
        
        bottomSheetView.addSubview(thinkTimeLabel)
        thinkTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).offset(commonPadding)
            make.leading.equalTo(self).offset(commonPadding)
        }
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(self).offset(20)
            make.width.height.equalTo(30)
        }
        
    }
    
    func configureByViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.title
        captionLabel.text = viewModel.content
        coperationNameButton.setTitle(viewModel.username, for: .normal)
        likesLabel.text = viewModel.likesLabelText
        thinkTimeLabel.text = viewModel.timestampString
    }
    
    //MARK: - Actions
    
    @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translation(in: self).y
        let minY = bottomSheetView.frame.minY // 뭐지
        let offset = translationY + minY
        
        let imageHeight = imageHeight ?? 100
        let commonPadding: CGFloat = 20
        let totalViewHeight = commonPadding + coperationNameButton.intrinsicContentSize.height +
                              commonPadding + titleLabel.intrinsicContentSize.height +
                              commonPadding/2 + 0.7 + commonPadding + captionLabel.intrinsicContentSize.height +
                              commonPadding + thinkTimeLabel.intrinsicContentSize.height + commonPadding
        
        let maxBottomY = min(offset, imageHeight)
        
        UIView.animate(
            withDuration: 0.05,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.updateBottomSheetConstraints(max(min(self.safeAreaLayoutGuide.layoutFrame.height - totalViewHeight, 0), maxBottomY))
                self.layoutIfNeeded()
            },
            completion: nil
        )
        
        recognizer.setTranslation(.zero, in: self) // 뭐지
    }
    
    @objc func didTapBackButton() {
        popDelegate?.popNavgationPage()
    }
    
    @objc func didTapUsername() {
        
    }
    
    @objc func didTapLikeButton() {
        //        guard let post = viewModel?.post else { return }
        //        delegate?.cell(self, didLike: post)
    }
    
    @objc func didTapCommentButton() {
        
    }
    
    @objc func didTapExitButton() {
        
    }
    
    // MARK: - ETC
    
    func updateBottomSheetConstraints(_ offset: Double) {
        bottomSheetView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(offset)
        }
    }
    
    func bottomSheetYPosition(_ ratio: Double) -> Double {
        UIScreen.main.bounds.height * ratio
    }
    
    var isFullScreen: Bool {
        bottomSheetView.frame.minY == 40 + safeLayoutTopHeight
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
}
