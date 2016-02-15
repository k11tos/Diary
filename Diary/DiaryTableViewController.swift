//
//  DiaryTableViewController.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 1. 31..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import UIKit

class DiaryTableViewController: UITableViewController {
    
    var diaries = [Diary]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let savedDiaries = loadDiaries() {
            diaries += savedDiaries

        } else {
            loadSampleDiaries()
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadSampleDiaries() {
        
        let defaultPhoto = UIImage(named:"netbook")!
        
        let diary0 = Diary(date: NSDate(timeIntervalSince1970: 1000), subject: "subject0", content: "content0", photo: defaultPhoto)!
        let diary1 = Diary(date: NSDate(timeIntervalSince1970: 2000), subject: "subject1", content: "content1", photo: defaultPhoto)!
        let diary2 = Diary(date: NSDate(timeIntervalSince1970: 3000), subject: "subject2", content: "content2", photo: defaultPhoto)!
        
        diaries += [diary0, diary1, diary2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return diaries.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "DiaryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DiaryTableViewCell

        // Configure the cell...
        let diary = diaries[indexPath.row]
        let date = CommonUtil()
        
        cell.dateLabel.text = date.getTimeWithFormat(diary.date, type: "only short date")
        cell.subjectLabel.text = diary.subject

        return cell
    }
    
    @IBAction func unwindToDiaryList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddDiaryViewController, diary = sourceViewController.diary {

            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing diary.
                diaries[selectedIndexPath.row] = diary
                diaries.sortInPlace({$0.date.compare($1.date) == NSComparisonResult.OrderedAscending})

                //tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                tableView.reloadData()
            }
            else {
                // Add a new diary.
                //let newIndexPath = NSIndexPath(forRow: diaries.count, inSection: 0)
                diaries.append(diary)
                //tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                diaries.sortInPlace({$0.date.compare($1.date) == NSComparisonResult.OrderedAscending})

                tableView.reloadData()
            }
            
            saveDiaries()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            diaries.removeAtIndex(indexPath.row)
            saveDiaries()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let diaryDetailViewController = segue.destinationViewController as! AddDiaryViewController
            
            // Get the cell that generated this segue.
            if let selectedDiaryCell = sender as? DiaryTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedDiaryCell)!
                let selectedDiary = diaries[indexPath.row]
                diaryDetailViewController.diary = selectedDiary
            }
        }
        else if segue.identifier == "AddItem" {
            //print("Adding new diary.")
        }
    }
    
    // MARK: NSCoding
    func saveDiaries () {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(diaries, toFile: Diary.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save diaries...")
        }
    }
    func loadDiaries() -> [Diary]? {

        return NSKeyedUnarchiver.unarchiveObjectWithFile(Diary.ArchiveURL.path!) as? [Diary]
    }
}
