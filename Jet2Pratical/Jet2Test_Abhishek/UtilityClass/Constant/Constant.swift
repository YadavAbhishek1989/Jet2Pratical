//
//  Constant.swift
//  Jet2Test_Abhishek
//
//  Created by Abhishek Yadav on 28/06/20.
//  Copyright © 2020 Abhishek Yadav. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    static var appdelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK: - Common keys
     static let kProjectName                 = "Jet2"
    
    static let kCellIndetifier              = "atricleTableViewCell"
    static let ktitles                      = "Articles"
    static let kWebViewController           = "WebViewController"
    static let kMain                        = "Main"
   
    static let KNoInternetMessage           = "No Internet. Please check your internet connection"
   
    
    static let kWebServiceURL               = "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=1&limit=10"
    
      //MARK: - UI Related Keys
    static let kServiceType                 = "GET"
    static let kLikes                       = "Likes"
    static let kComments                    = "Comments"
    static let kdays                        = "Days"
    static let kdateTimeFormat              = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let kdateTimeIdentifier          = "en_US_POSIX"
    
    //MARK: - WebServie call related keys
    static let kid                          = "id"
    static let kmedia                       = "media"
    static let kuser                        = "user"
    
    static let kcreatedAt                   = "createdAt"
    static let kcomments                    = "comments"
    static let kcontent                     = "content"
    static let klikes                       = "likes"
    
    static let kname                        = "name"
    static let klastname                    = "lastname"
    static let kdesignation                 = "designation"
    static let kavatar                      = "avatar"
    
    static let kimage                       = "image"
    static let kurl                         = "url"
    static let ktitle                       = "title"
    
}

//MARK: - Extension Here

//MARK: - No of likes and Comments Thousand and Milllions
extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}

//MARK: - ImageView Url load and Cornor Borders
extension UIImageView {
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func imageViewRoundCornor(tblViewCell: atricleTableViewCell) {
        tblViewCell.userImageView.backgroundColor = .lightGray
        tblViewCell.userImageView.layer.cornerRadius = 15
        tblViewCell.userImageView.layer.borderWidth = 1
        tblViewCell.userImageView.layer.borderColor = UIColor.blue.cgColor
    }
}

//MARK: - Days get from two dates.
extension Date {

    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }

    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)

        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
}

//MARK: - Alert Show
extension UIViewController {
    // Alert with OK Button
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

