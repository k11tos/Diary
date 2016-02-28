//
//  InfoViewController.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 2. 16..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.webView.delegate = self
        super.viewDidLoad()
        
        let str = NSURL(string: "https://dl.dropboxusercontent.com/s/obf0hoh2v9wz6up/diary.html")
        let request = NSURLRequest(URL: str!)
        
        webView.loadRequest(request)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.spinner.startAnimating()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.spinner.stopAnimating()
        
        let alert = UIAlertController(title: "오류", message: "페이지를 읽어오지 못했습니다.", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "확인", style: .Cancel) {(_) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: false, completion: nil)
    }
}
