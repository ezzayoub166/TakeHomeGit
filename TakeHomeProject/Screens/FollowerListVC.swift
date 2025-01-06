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
    var userName : String?
    var followers : [Follower] = []
    
    var colloctionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section , Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()


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
        colloctionView.backgroundColor = .systemBackground
        colloctionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        
    }
    
    
    func getFollowers(){
        
        NetworkManager.shared.getFollowers(for: userName!, page: 1) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let followers):
                self.followers = followers
                self.updateData()
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
    
    func updateData(){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

}

