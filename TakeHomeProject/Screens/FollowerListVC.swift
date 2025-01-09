//
//  FollowerListVC.swift
//  TakeHomeProject
//
//  Created by ezz on 29/12/2024.
//

import UIKit

class FollowerListVC: UIViewController {
    
    
    enum Section {
        case main
    }
    var userName : String!
    var page     : Int                = 1
    var hasMoreFollowers              = true
    var isSearching                   = false
    var followers : [Follower]        = []
    var filterdFollowers : [Follower] = []
    
    
    var colloctionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section , Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: userName, page: page)
        configureDataSource()
        configureSearchController()



    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView(){
        colloctionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(colloctionView)
        colloctionView.delegate        = self
        colloctionView.backgroundColor = .systemBackground
        colloctionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        
    }
    
    func configureSearchController(){
        let searchController                                  = UISearchController()
        searchController.searchResultsUpdater                 = self
        searchController.searchBar.placeholder                = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate                   = self
        navigationItem.searchController                       =  searchController
    }
    
    
    func getFollowers(username : String , page : Int){
        showLoadingView()
        NetworkManager.shared.getFollowers(for: userName!, page: page) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
    
                if followers.count < 100 {self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    let message = "This user dosen't have any followers.Go Follow them.😃"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happen",
                                                message: error.rawValue
                                           , buttonTitle: "Okay")
            }
        }
    }
    
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: colloctionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    
    func updateData(on followers : [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

}

extension FollowerListVC : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY       = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height        = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {return}
            page += 1
            getFollowers(username: userName, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filterdFollowers : followers
        let follower = activeArray[indexPath.item]
         let desVC      = UserInfoVC()
         desVC.username  = follower.login
         let navC       = UINavigationController(rootViewController: desVC)
         self.present(navC, animated: true)
        
    }
}
extension FollowerListVC : UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text , !filter.isEmpty else {return}
        isSearching = true
        filterdFollowers = followers.filter{$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filterdFollowers)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
    
    
}
