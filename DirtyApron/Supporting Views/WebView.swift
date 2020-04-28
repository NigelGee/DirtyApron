//
//  WebView.swift
//  DirtyApron
//
//  Created by Nigel Gee on 09/04/2020.
//  Copyright © 2020 Nigel Gee. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var website: String
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: "https://" + website) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
}

