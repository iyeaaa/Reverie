//
//  SearchController.swift
//  InstagramFirestoreTutorial
//
//  Created by 이예인 on 2023/08/06.
//

import UIKit

private let thinkCellIdentifier = "ProfileCell"

class SearchController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UserCell.self, forCellReuseIdentifier: UserCell.id)
        $0.rowHeight = 64
    }
    
    private var users = [User]()
    private var filteredUsers = [User]()
    
    private var thinks = [Think]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && searchController.searchBar.text?.isEmpty == false
    }
    
    // MARK: - UI Properties
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            let width = (view.frame.width - 2) / 3
            $0.itemSize = CGSize(width: width, height: width)
            $0.minimumLineSpacing = 1
            $0.minimumInteritemSpacing = 1
        }
    ).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.register(ProfileCell.self, forCellWithReuseIdentifier: thinkCellIdentifier)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAutoLayout()
    }
    
    // MARK: - Configures
    
    func configure() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        fetchUsers()
        fetchThinks()
        configureSearchController()
    }
    
    func configureAutoLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false // true면 입력하는동안 불투명효과
        searchController.hidesNavigationBarDuringPresentation = false // 입력하는동안 네비게이션바 가릴지 설정
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    func fetchThinks() {
        ThinkService.fetchThinks { thinks in
            self.thinks = thinks
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
}

// MARK: - UITableViewDataSource

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.id, for: indexPath) as! UserCell
        cell.viewModel = UserCellViewModel(user: inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row])
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ProfileController(user: inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: thinkCellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = ThinkCellViewModel(think: thinks[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let contoller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
//        contoller.post = thinks[indexPath.row]
//        navigationController?.pushViewController(contoller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter{ $0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText) }
        self.tableView.reloadData()
    }
}
