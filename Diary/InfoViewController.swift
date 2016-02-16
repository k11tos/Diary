//
//  InfoViewController.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 2. 16..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
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

}
