//
//  SplashScreenVC.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//


import UIKit

class SplashScreenVC: UIViewController {

    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var appLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSplashScreen()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateSplashScreen()
    }
    
    func setupSplashText() {
        // Article label
        articleLabel.text = "Article"
        articleLabel.font = .systemFont(ofSize: 42, weight: .bold)
        articleLabel.textColor = .white
        articleLabel.textAlignment = .center
        articleLabel.alpha = 0

        // App label
        appLabel.text = "App"
        appLabel.font = .systemFont(ofSize: 42, weight: .bold)
        appLabel.textColor = .systemBlue
        appLabel.textAlignment = .center
        appLabel.alpha = 0

    }

    private func setupSplashScreen() {
        // Initial hidden state
        articleLabel.alpha = 0
        appLabel.alpha = 0
        
        setupSplashText()

        // Start below their original positions
        articleLabel.transform = CGAffineTransform(
            translationX: 0,
            y: 100
        )

        appLabel.transform = CGAffineTransform(
            translationX: 0,
            y: 100
        )
        
        
    }

    private func animateSplashScreen() {
        // Animate Article from bottom
        UIView.animate(
            withDuration: 0.6,
            delay: 0.2,
            usingSpringWithDamping: 0.82,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut]
        ) {
            self.articleLabel.alpha = 1
            self.articleLabel.transform = .identity
        } completion: { _ in

            // Animate App after Article
            UIView.animate(
                withDuration: 0.6,
                delay: 0.15,
                usingSpringWithDamping: 0.82,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut]
            ) {
                self.appLabel.alpha = 1
                self.appLabel.transform = .identity
            } completion: { _ in

                // Wait briefly, then open HomeScreenVC
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.6
                ) {
                    self.openHomeScreen()
                }
            }
        }
    }

    private func openHomeScreen() {

        
        
        let homeVC = HomeScreenVC(
            nibName: "HomeScreenVC",
            bundle: nil
        )

        homeVC.modalPresentationStyle = .fullScreen

        navigationController?.setViewControllers(
            [homeVC],
            animated: true
        )

//        UIView.transition(
//            with: self.view.window!,
//            duration: 0.35,
//            options: .transitionCrossDissolve
//        ) {
//            self.view.window?.rootViewController = homeVC
//        }
    }
}
