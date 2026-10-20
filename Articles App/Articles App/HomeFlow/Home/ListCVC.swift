//
//  ListCVC.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//

import UIKit
import Kingfisher

class ListCVC: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReadMore: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewAction: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLabels()
    }
    
    
    @IBAction func onClickReadMore(_ sender: Any) {
    }
    
    
    func setupLabels() {
        // Title
        lblTitle.font = .robotoSemiBold(size: 16)
        lblTitle.textColor = .white
        
        // Read More
        lblReadMore.font = .montserratSemiBold(size: 13)
        lblReadMore.textColor = .white
        
        // Date
        lblDate.font = .montserratRegular(size: 13)
        lblDate.textColor = UIColor.Color969696
        
        viewMain.layer.cornerRadius = 8
        viewMain.clipsToBounds = true
        
        viewAction.layer.cornerRadius = 8
        viewAction.clipsToBounds = true
    }
    
    
    func setCellData(_ article: Article) {
        
        // Article title
        lblTitle.text = article.title
        
       
        lblReadMore.text = "Read More"
        
        // Published date
        if let publishedAt = article.publishedAt {
            let inputFormatter = ISO8601DateFormatter()
            
            if let date = inputFormatter.date(from: publishedAt) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "dd MMM, yyyy"
                outputFormatter.locale = Locale(identifier: "en_US_POSIX")
                
                lblDate.text = outputFormatter.string(from: date)
            } else {
                lblDate.text = ""
            }
        } else {
            lblDate.text = ""
        }
        
        
        // Placeholder image
        let placeholder = UIImage(named: "imgBook")
        
        // Load image from URL
        guard let imageURL = article.urlToImage,
              let url = URL(string: imageURL) else {
            imgArticle.image = placeholder
            return
        }
        
        imgArticle.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.25))]
        ) { [weak self] result in
            
            if case .failure = result {
                self?.imgArticle.image = placeholder
            }
        }
    }
    
}
