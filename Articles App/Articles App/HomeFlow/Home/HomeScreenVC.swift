//
//  HomeScreenVC.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON
import Network

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgListType: UIImageView!
    
    @IBOutlet weak var cvList: UICollectionView!
    
    
    //offline sectoion
    
    
    @IBOutlet weak var viewOffline: UIView!
   
    @IBOutlet weak var lblOfflineSub: UILabel!
    @IBOutlet weak var lblOfflineTitle: UILabel!
    @IBOutlet weak var viewReload: UIView!
    
    @IBOutlet weak var lblRetry: UILabel!
    
    private var isGrid = true
    
    
    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "HomeNetworkMonitor")
    private var wasConnected: Bool?
    
    var articles: [Article] = []
    private var networkObserverID: UUID?
    
    private let articlesURL =
    "https://mocki.io/v1/9f09ed09-d8ca-48c7-9957-dec39e745321"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblTitle.font = .robotoCondensedBlack(size: 30)
        lblTitle.textColor = .black
        lblTitle.text = "Articles"
        
        getArticles()
        
        setupNetworkMonitoring()
        
        setupCollectionView()
        
        setOfflineView()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            let isConnected = path.status == .satisfied

            DispatchQueue.main.async {
                self.viewOffline.isHidden = isConnected

                print("Network connected:", isConnected)

                
                if isConnected && self.wasConnected == false {
                    self.getArticles()
                }

                self.wasConnected = isConnected
            }
        }

        networkMonitor.start(queue: networkQueue)
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func setOfflineView(){
        
        viewReload.layer.cornerRadius =  viewReload.bounds.height / 2
        
        lblOfflineTitle.font = .robotoBold(size: 18)
        lblOfflineTitle.textColor = .black
        
        lblOfflineSub.font = .robotoLight(size: 18)
        lblOfflineSub.textColor = .black.withAlphaComponent(0.6)
        
        lblRetry.font = .robotoBold(size: 16)
        lblRetry.textColor = .black
        
        
    }
    
    
    private func setupCollectionView() {
        cvList.delegate = self
        cvList.dataSource = self
        
        
        // Register Grid Cell XIB
        cvList.register(
            UINib(nibName: "GridCVC", bundle: nil),
            forCellWithReuseIdentifier: "GridCVC"
        )
        
        // Register List Cell XIB
        cvList.register(
            UINib(nibName: "ListCVC", bundle: nil),
            forCellWithReuseIdentifier: "ListCVC"
        )
        
        
        cvList.contentInset = UIEdgeInsets(
            top: 8,
            left: 8,
            bottom: 20,
            right: 8
        )
        
        cvList.showsVerticalScrollIndicator = false
        
        cvList.collectionViewLayout = createCollectionViewLayout()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = isGrid ? 8 : 12
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(
            top: 4,
            left: 4,
            bottom: 12,
            right: 4
        )
        
        return layout
    }
    
    
    @IBAction func onClickListBtn(_ sender: Any) {
        if isGrid {
            imgListType.image = UIImage(named: "iconList")
        } else {
            imgListType.image = UIImage(named: "iconGrid")
        }
        isGrid.toggle()
        
        cvList.collectionViewLayout = createCollectionViewLayout()
        cvList.reloadData()
        
        cvList.setContentOffset(
            CGPoint(
                x: cvList.contentOffset.x,
                y: -cvList.adjustedContentInset.top
            ),
            animated: false
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    @IBAction func onClickRetry(_ sender: Any) {
        getArticles()
    }
    
    
}



extension HomeScreenVC: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        // Replace articles.count with your existing data source count.
        return articles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if !isGrid {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "GridCVC",
                for: indexPath
            ) as! GridCVC
            if let article = articles[indexPath.item] as? Article {
                cell.setCellData(article)
            }
            // Configure your existing GridCVC outlets here.
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ListCVC",
                for: indexPath
            ) as! ListCVC
            if let article = articles[indexPath.item] as? Article {
                cell.setCellData(article)
            }
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard indexPath.item < articles.count else { return }

        let article = articles[indexPath.item]

        let detailVC = DetaileScreenVC(
            nibName: "DetaileScreenVC",
            bundle: nil
        )

        detailVC.article = article

        navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }
}



extension HomeScreenVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let sectionInsets: CGFloat = 4
        let spacing: CGFloat = 8
        
        let availableWidth = collectionView.bounds.width
        - collectionView.adjustedContentInset.left
        - collectionView.adjustedContentInset.right
        - (sectionInsets * 2)
        
        if !isGrid {
            // Two equal-width cards
            let itemWidth = (availableWidth - spacing) / 2
            
            return CGSize(
                width: floor(itemWidth),
                height: 160
            )
        } else {
            // One full-width article card
            return CGSize(
                width: floor(availableWidth),
                height: 335
            )
        }
    }
}


extension HomeScreenVC {
    func getArticles() {
        AF.request(articlesURL)
            .validate()
            .responseJSON { [weak self] response in
                guard let self = self else { return }

              //  self.viewOffline.isHidden = true
                
                switch response.result {
                case .success(let value):

                    let json = JSON(value)
                    let result = ArticlesResponse(json: json)

                    self.articles = result.articles
                    self.viewOffline.isHidden = true
                    print("Status: \(result.status)")
                    print("Total results: \(result.totalResults)")
                    print("Articles loaded: \(result.articles.count)")

                    DispatchQueue.main.async {
                        self.cvList.reloadData()
                    }

                case .failure(let error):
                    print("Articles API error: \(error)")
                }
            }
    }
}


//offline section
extension HomeScreenVC {
  
    
    
}
