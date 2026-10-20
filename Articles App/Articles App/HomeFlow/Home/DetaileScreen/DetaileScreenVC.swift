//
//  DetaileScreenVC.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//

import UIKit
import SwiftUI

class DetaileScreenVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var article: Article!
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblArticle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupArticleDetail()
        
        viewBack.layer.cornerRadius = viewBack.bounds.height / 2
        lblArticle.font = UIFont.robotoMedium(size: 20)
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func setupArticleDetail() {
        guard let article = article else { return }

        let detailView = ArticleDetailView(article: article)
        let hostingController = UIHostingController(
            rootView: detailView
        )

        hostingController.view.backgroundColor = .clear
        hostingController.view.isOpaque = false
        hostingController.view.clipsToBounds = false
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(hostingController)

        containerView.backgroundColor = .clear
        containerView.clipsToBounds = false
        containerView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(
                equalTo: containerView.topAnchor
            ),
            hostingController.view.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor
            ),
            hostingController.view.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor
            ),
            hostingController.view.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor
            )
        ])

        hostingController.didMove(toParent: self)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
