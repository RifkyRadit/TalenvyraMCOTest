//
//  ArticleDetailView.swift
//  MandiriNews
//
//  Created by Rifky Radityatama on 06/06/26.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController, ArticleDetailViewProtocol {
    var presenter: ArticleDetailPresenterProtocol?
    
    private let webView = WKWebView()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Article Detail"
        
        setupWebView()
        presenter?.viewDidLoad()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
        view.addSubview(loadingView)
        loadingView.center = view.center
        loadingView.hidesWhenStopped = true
    }
    
    func loadWebPage(with urlString: String) {
        guard let URLImage = URL(string: urlString) else { return }
        let request = URLRequest(url: URLImage)
        webView.load(request)
    }
}

extension ArticleDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        loadingView.stopAnimating()
    }
}
