//
//  ViewController.swift
//  Jet2Test_Abhishek
//
//  Created by Abhishek Yadav on 26/06/20.
//  Copyright © 2020 Abhishek Yadav. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblArticles : UITableView!
    
    var context:NSManagedObjectContext!
    
    var article = [Article]()
    var arrDataArticles : [[String : Any]] = [[:]]
        
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Title and Tableview Footer View
        self.title = Constant.ktitles
        self.tblArticles.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
     //MARK: - ViewWillAppear and WebService Call here
    override func viewWillAppear(_ animated: Bool) {
        
        self.callArticleWebService()
    }
    
    //MARK: - UITableViewCell DataSource and Delegate.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let articleCell = tableView.dequeueReusableCell(withIdentifier: Constant.kCellIndetifier, for: indexPath) as! atricleTableViewCell
        articleCell.selectionStyle = .none
        
        // User ImageView Round and Cornor
        articleCell.userImageView.imageViewRoundCornor(tblViewCell: articleCell)
        
        let imageUrl = NSURL(string: article[indexPath.row].avatar!)
        // Image Load for Image URl
        articleCell.userImageView.loadImage(url: imageUrl! as URL)
        
        // Set User Name
        let strFirstName = article[indexPath.row].name ?? ""
        let strLastName = article[indexPath.row].lastname ?? ""
        
        articleCell.lbluserName.text = "\(strFirstName) \(strLastName)"
        
         // Set User Designation
        articleCell.lblUserDesignation.text = article[indexPath.row].designation ?? ""
               
        // Article Image
        let articleImage = NSURL(string: article[indexPath.row].image!)
        articleCell.imgVwArticle.loadImage(url: articleImage! as URL)
        
        // Set Article Title and Connent
        articleCell.textViewArticleContent.text = "\(article[indexPath.row].title ?? "")\n\n \(article[indexPath.row].content ?? "")"
        
        // Set Article URL
        articleCell.btnUrl.setTitle(article[indexPath.row].url ?? "", for: .normal)
        articleCell.btnUrl.setTitle(article[indexPath.row].url ?? "", for: .highlighted)
        articleCell.btnUrl.setTitle(article[indexPath.row].url ?? "", for: .selected)
        
        articleCell.btnUrl.accessibilityLabel = article[indexPath.row].url ?? ""
        articleCell.btnUrl.addTarget(self, action: #selector(btnURlAction(sender:)), for: .touchUpInside)
        
        // Set Likes
        let likesCount = ("\(Int(article[indexPath.row].likes).roundedWithAbbreviations) \(Constant.kLikes)")
        articleCell.lblArticleLikes.text = String(likesCount)
        
        // Set Comments
        let commentsCount = ("\(Int(article[indexPath.row].comments).roundedWithAbbreviations) \(Constant.kComments)")
        articleCell.lblArticleComment.text = String(commentsCount)
        
        // Set Article DateTime into Days
        let isoDate = article[indexPath.row].createdAt ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Constant.kdateTimeIdentifier) // set locale to reliable US_POSIX
        dateFormatter.dateFormat = Constant.kdateTimeFormat
        let articledate = dateFormatter.date(from:isoDate)!
        
        let numberOfDays = daysBetweenDates(startDate:articledate as NSDate, endDate: Date.init() as NSDate)
        articleCell.lblPostTime.text = "\(numberOfDays) \(Constant.kdays)"
          
        return articleCell
    }
    
    //MARK: - Btn Article URl Action here
    @objc func btnURlAction(sender: UIButton) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: Constant.kMain, bundle: nil)
        let webViewVC = storyboard.instantiateViewController(withIdentifier: Constant.kWebViewController) as! WebViewController
        webViewVC.strWebLink = sender.accessibilityLabel ?? ""
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }
        
    //MARK: - Article WebService Call
    func callArticleWebService()  {
        
        if Reachability.isConnectedToNetwork() {
            
            let restAPICall = RequestManager()
            restAPICall.GETServiceCall(url: Constant.kWebServiceURL, parameter: "", completion: { [unowned self] response,Data,Error  in
                let Responses = response as? HTTPURLResponse
                DispatchQueue.main.async {
                    if Error != nil {
                        let errordes = Error?.userInfo
                        print(errordes as Any)
                        return
                    } else if Responses?.statusCode == 200 {
                        print("Success")
                        //  WebService call Successfull...
                        // Data stored in Json Format
                        self.arrDataArticles = (Data! as! [[String : Any]])
                        print(self.arrDataArticles)
                        if self.arrDataArticles.count != 0 {
                            
                            // Delete all Record from Table.
                            Constant.appdelegate.deleteArticleAllRecords()
                            
                            for articleData in self.arrDataArticles {
                                let article = Article(context:  Constant.appdelegate.persistentContainer.viewContext)
                                
                                // Article releated stored in CoreData Entity here
                                article.id = articleData[Constant.kid] as? String
                                
                                article.createdAt           = articleData[Constant.kcreatedAt] as? String
                                article.comments            = articleData[Constant.kcomments] as! Int64
                                article.content             = articleData[Constant.kcontent] as? String
                                article.likes               = articleData[Constant.klikes] as! Int64
                                
                                // User releated stored in CoreData Entity here
                                let userData = articleData[Constant.kuser] as! [[String: Any]]
                                
                                article.name                = userData[0][Constant.kname] as? String
                                article.lastname            = userData[0][Constant.klastname] as? String
                                article.designation         = userData[0][Constant.kdesignation] as? String
                                article.avatar              = userData[0][Constant.kavatar] as? String
                                
                                // Media releated stored in CoreData Entity here
                                let mediaData = articleData[Constant.kmedia] as! [[String: Any]]
                                
                                article.image               = mediaData[0][Constant.kimage] as? String
                                article.url                 = mediaData[0][Constant.kurl] as? String
                                article.title               = mediaData[0][Constant.ktitle] as? String
                                
                                // Store all data in Coredata.
                                Constant.appdelegate.saveContext()
                            }
                        }
                        // Fetch Data func Call.
                        self.fetchData()
                        
                    } else {
                        let strStausCode: Int = Responses?.statusCode ?? 0
                        self.showAlert(message: "Web Service call Error with code --- > \(strStausCode)", title: Constant.kProjectName)
                    }
                }
            })
            
        } else {
            self.showAlert(message: Constant.KNoInternetMessage, title: Constant.kProjectName)
        }
    }
    
    //MARK: - Fetch Data from Article
    func fetchData() {
        
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
      
        do {
            let articleData = try  Constant.appdelegate.persistentContainer.viewContext.fetch(fetchRequest)
            self.article = articleData
            self.tblArticles.reloadData()
        } catch {
            print("Error --> Fetch Data error.")
        }
    }
    
    //MARK: - DateTime Convert into Days here
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int {
        
        let diff = Date.daysBetween(start: startDate as Date, end: endDate as Date)
        return diff
    }
}


//MARK: - UITableViewCell Define here
class atricleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var lblUserDesignation: UILabel!
    
    @IBOutlet weak var lblPostTime : UILabel!
    
    @IBOutlet weak var imgVwArticle: UIImageView!
    
    @IBOutlet weak var textViewArticleContent: UITextView!
    
    @IBOutlet weak var lblArticleLikes: UILabel!
    @IBOutlet weak var lblArticleComment: UILabel!
    
    @IBOutlet weak var btnUrl: UIButton!
    
}
