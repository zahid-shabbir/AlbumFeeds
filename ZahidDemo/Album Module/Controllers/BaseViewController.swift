//
//  BaseViewController.swift
//  ZahidDemo
//
//  Created by Zahid Shabbir on 27/02/2021.
//
    import UIKit
class BaseViewController: UIViewController {
    // MARK: - Connections & Variables
    let activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .medium)
    // MARK: - Views Life cycle
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        }
    /// Show Progress Bar
    func showProgress() {
        DispatchQueue.main.async {
                            // Place the activity indicator on the center of your current screen
            self.activityIndicator?.center = self.view.center
                    // In most cases this will be set to true, so the indicator hides when it stops spinning
            self.activityIndicator?.hidesWhenStopped = true
                    // Start the activity indicator and place it onto your view
            self.activityIndicator?.startAnimating()
            self.view.addSubview(self.activityIndicator!)
                        }
    }
    /// Hide Progress bar
    func hideProgress() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
        }
        }
}
