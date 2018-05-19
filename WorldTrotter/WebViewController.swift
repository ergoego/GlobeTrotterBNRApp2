//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Erik Olson on 10/3/17.
//  Copyright © 2017 Erik Olson. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .null, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }}
