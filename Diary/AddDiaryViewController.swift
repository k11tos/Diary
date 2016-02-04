//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 1. 31..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController, UITextFieldDelegate/*, UITextViewDelegate*/ {

    @IBOutlet weak var subjectText: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancel(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
        
        let isPresentingInAddDiaryMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDiaryMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    var diary = Diary?()
    var currentDate:NSDate = NSDate()
    
    override func viewDidLoad() {
        
        currentDate = NSDate()
        let dateUtil = CommonUtil()
        dateLabel.text = dateUtil.getTimeWithFormat(currentDate, type: "short")
        super.viewDidLoad()
        
        subjectText.delegate = self
        //contentText.delegate = self
        
        contentText.layer.cornerRadius = 5
        
        if let diary = diary {
            navigationItem.title = "일기 읽어보기 / 수정하기"
            subjectText.text = diary.subject
            currentDate = diary.date
            dateLabel.text   = dateUtil.getTimeWithFormat(currentDate, type: "short")
            contentText.text = diary.content
        }
        
        checkValidDiaryName()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidDiaryName() {
        // Disable the Save button if the text field is empty.
        let text = subjectText.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDiaryName()
        //navigationItem.title = "새 일기 쓰기"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender {
            let subject = subjectText.text
            let date = currentDate
            let content = contentText.text
            
            // Set the diary to be passed to DiaryTableViewController after the unwind segue.
            diary = Diary(date: date, subject: subject!, content: content)
        }
    }
}
