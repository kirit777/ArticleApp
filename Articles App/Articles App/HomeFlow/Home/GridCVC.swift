//
//  GridCVC.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//

import UIKit
import Kingfisher

class GridCVC: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabels()
        // Initialization code
    }
    
    func setupLabels() {
        // Title
        lblTitle.font = .robotoSemiBold(size: 16)
        lblTitle.textColor = .white
        
       
        viewMain.layer.cornerRadius = 8
        viewMain.clipsToBounds = true
    }
    
    
    func setCellData(_ article: Article) {
        
        // Article title
        lblTitle.text = article.title
        
        
        
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
