//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 1. 31..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddDiaryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties
    let datePickerView  = UIDatePicker()
    var diary           = Diary?()
    var currentDate     = NSDate()
    let locationManager = CLLocationManager()
    var location        = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    let regionRadious:CLLocationDistance = 1000

    
    @IBOutlet weak var subjectText  : UITextField!
    @IBOutlet weak var contentText  : UITextView!
    @IBOutlet weak var diaryScroll  : UIScrollView!
    @IBOutlet weak var photoImage   : UIImageView!
    
    @IBOutlet weak var saveButton   : UIBarButtonItem!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mapView      : MKMapView!

    // MARK: UITextFieldDelegate
    @IBAction func dateTextFieldEditing(sender: UITextField) {
        
        datePickerView.locale         = NSLocale(localeIdentifier: "ko_KR")
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        let toolBar = UIToolbar(frame: CGRectMake(0,0,320,44))
        let doneBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.showSelectedDate))
        let space   = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var items   = [UIBarButtonItem]()
        items.append(space)
        items.append(doneBtn)
        toolBar.setItems(items, animated: true)
        
        sender.inputView          = datePickerView
        sender.inputAccessoryView = toolBar
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

    // MARK: UITextViewDelegate

    func textViewDidBeginEditing(textView: UITextView) {
        let orientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            diaryScroll.setContentOffset(CGPointMake(0, 280), animated: true)
        } else if (UIInterfaceOrientationIsPortrait(orientation)) {
            diaryScroll.setContentOffset(CGPointMake(0, 120), animated: true)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImage.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender {
            let subject   = subjectText.text
            let date      = currentDate
            let content   = contentText.text
            let photo     = photoImage.image
            let latitude  = location.latitude
            let longitude = location.longitude

            // Set the diary to be passed to DiaryTableViewController after the unwind segue.
            diary = Diary(date     : date,
                          subject  : subject!,
                          content  : content,
                          photo    : photo,
                          latitude : latitude,
                          longitude: longitude)
        }
    }
    
    // MARK: Actions
    
    func showSelectedDate () {
        let dateUtil = CommonUtil()
        dateTextField.text = dateUtil.getTimeWithFormat(self.datePickerView.date, type: "only short date")

        currentDate        = self.datePickerView.date
        dateTextField.resignFirstResponder()
    }
    
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        subjectText.resignFirstResponder()
        contentText.resignFirstResponder()
        
        /*
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate   = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
*/
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertActionView = UIAlertController(title: "Image", message: "Select an option how to get the image", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let camera = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            imagePickerController.sourceType = .Camera
            alertActionView.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        let photo = UIAlertAction(title: "Find in photo library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            imagePickerController.sourceType = .PhotoLibrary
            alertActionView.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
            alertActionView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertActionView.addAction(camera)
        alertActionView.addAction(photo)
        alertActionView.addAction(cancel)
        presentViewController(alertActionView, animated: true, completion: nil)
        
    }

    @IBAction func setCurrentLocation(sender: UITapGestureRecognizer) {
        let location = getCurrentLocationFromGPS()
        setCurrentLocationToMap(location)
    }

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
    
    override func viewDidLoad() {
        
        currentDate  = NSDate()
        let dateUtil = CommonUtil()
        dateTextField.text = dateUtil.getTimeWithFormat(currentDate, type: "only short date")
        super.viewDidLoad()
        
        var currentLocation = CLLocationCoordinate2D(latitude: 0,longitude: 0)

        subjectText.delegate = self
        contentText.delegate = self
        
        contentText.layer.cornerRadius = 5
        
        self.diaryScroll.contentSize.height = 100
        
        if let diary = diary {
            navigationItem.title = "일기 읽어보기 / 수정하기"
            subjectText.text     = diary.subject
            currentDate          = diary.date
            dateTextField.text   = dateUtil.getTimeWithFormat(currentDate, type: "only short date")
            contentText.text     = diary.content
            photoImage.image     = diary.photo
            
            currentLocation.latitude  = diary.latitude
            currentLocation.longitude = diary.longitude

        } else {
            currentLocation = getCurrentLocationFromGPS()
        }

        setCurrentLocationToMap(currentLocation)
        checkValidDiaryName()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter  = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getCurrentLocationFromGPS () -> CLLocationCoordinate2D {
        
        var currentLocation = CLLocationCoordinate2D(latitude: 0,longitude: 0)
        
        initLocationManager()
        
        if let locationManagerLocation = locationManager.location {
            locationManager.startUpdatingLocation()
            currentLocation = locationManagerLocation.coordinate
            locationManager.stopUpdatingLocation()
        } else {
            currentLocation.latitude  = 0
            currentLocation.longitude = 0
        }
        
        return currentLocation
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse
        {
            let currentLocation = getCurrentLocationFromGPS()
            setCurrentLocationToMap(currentLocation)
        }
    }
    
    func setCurrentLocationToMap (location:CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadious, regionRadious)
        let point = MKPointAnnotation()
        point.coordinate = location

        self.mapView.setRegion(coordinateRegion, animated: true)
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(point)
    }
}
