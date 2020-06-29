//
//  RequestManager.swift
//  Jet2Test_Abhishek
//
//  Created by Abhishek Yadav on 28/06/20.
//  Copyright © 2020 Abhishek Yadav. All rights reserved.
//

import Foundation

class RequestManager {
    // MARK: -  Shared Instance
    static let sharedInstance : RequestManager = {
        let instance = RequestManager()
        return instance
    }()
    
    // MARK: -  Call GET Service...
    public func GETServiceCall(url: String, parameter: String,completion: @escaping (_ dataresponse: URLResponse?,_ data: NSArray?, _ error: NSError? ) -> Void) {
        
        // Encode string due to Japanese come in String...
        guard let escapedString = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else { return  }
        
        var request = URLRequest(url: URL(string: escapedString)!)
        request.httpMethod = "GET"
        
        let postString = parameter
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { Data, response, error in
            // Reponse Handle here
            guard let data = Data, error == nil else {  // check for fundamental networking error
                print("error=\(String(describing: error))")
                completion((response as URLResponse?),[[:]], error as NSError?)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {  // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print(response!)
                let dict = [["message": String(data: data, encoding: .utf8)!]]
                completion(response!,dict as NSArray, error as NSError?)
                return
            }
            
            let responseString  = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
            completion(response! as URLResponse,responseString ?? [[:]], error as NSError?)
        }
        task.resume()
    }
}
