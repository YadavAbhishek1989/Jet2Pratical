//
//  WebViewController.swift
//  Jet2Test_Abhishek
//
//  Created by Abhishek Yadav on 28/06/20.
//  Copyright © 2020 Abhishek Yadav. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
   @IBOutlet weak var webView: WKWebView!
    
    var strWebLink : String = ""

    //MARK: - Article WebView Call
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - WeKit URl load here.
    override func viewWillAppear(_ animated: Bool) {
        
        let url = URL(string: strWebLink)
        webView.load(URLRequest(url: url!))
    }
}
