//
//  VKLoginController.swift
//  VKApi
//
//  Created by Тимур Фатулоев on 13.08.2020.
//  Copyright © 2020 Тимур Фатулоев. All rights reserved.
//

import UIKit
import WebKit

class VKLoginController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.load(NetworkService.shared.getAuthorized())
    }
    
}

extension VKLoginController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
                  url.path == "/blank.html",
                  let fragment = url.fragment else { decisionHandler(.allow); return }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        print(params)
        
        guard
            let token = params["access_token"],
            let userId = Int(params["user_id"]!) else {
            decisionHandler(.cancel)
            return
        }
        
        Session.shared.token = token
        print(token, userId)
        
        performSegue(withIdentifier: "webViewOAuth", sender: nil)
        decisionHandler(.cancel)
    }
}
