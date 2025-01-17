//
//  UIViewController+Ex.swift
//  TakeHomeProject
//
//  Created by ezz on 29/12/2024.
//

import UIKit

fileprivate var containerView : UIView!

extension UIViewController {
    func presentGFAlertOnMainThread(title : String , message : String , buttonTitle : String){
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle   = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha           = 0
        UIView.animate(withDuration: 0.25) { containerView.alpha =  0.8}
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                containerView.alpha = 0.0
            } completion: { (true) in
                containerView.removeFromSuperview()
                containerView = nil
            }
        }
    }
    
    func showEmptyStateView(with message : String , in view: UIView){
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
