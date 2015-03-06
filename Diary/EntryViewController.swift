//
//  EntryViewController.swift
//  Diary
//
//  Created by Tim Walsh on 3/3/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import CoreLocation


class EntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate  {
    

    var entry: DiaryEntry?
    var pickedMood: DiaryEntry.DiaryEntryMood?
    var pickedImage: UIImage {
        get {
            return self.imageButton.imageForState(UIControlState.Normal)!
        }
        set {
            self.imageButton.setImage(newValue, forState: UIControlState.Normal)
        }
    }
    var imagePicker: UIImagePickerController?
    var locationManager: CLLocationManager?
    var location: String = ""

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var averageButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet var accessoryView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var date = NSDate()
        
        if let newEntry = entry { //if entry is not nil then we want to edit the body of the passed entry
            self.textView.text = newEntry.body
            self.setPickedMood(DiaryEntry.DiaryEntryMood(rawValue: newEntry.mood)!)
            date = NSDate(timeIntervalSince1970: newEntry.date)
            self.imageButton.setImage(UIImage(data: newEntry.imageData), forState: UIControlState.Normal) 
        } else {
            println("making a new entry")
            self.setPickedMood(DiaryEntry.DiaryEntryMood.DiaryEntryMoodGood)
            self.loadLocation()
        }
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE MMMM d, yyyy")
        self.dateLabel.text = dateFormatter.stringFromDate(date)
        
        
        self.textView.inputAccessoryView = self.accessoryView
        
        self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textView.becomeFirstResponder()
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
    
    //MARK: - location management including delegate
    
    func loadLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        self.locationManager!.desiredAccuracy = 1000
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {//this is required, but should only be seen once
            locationManager!.requestWhenInUseAuthorization()
        }
        
        
        //self.locationManager!.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager?.stopUpdatingLocation()
        
        let location  = locations.first as CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (objects: [AnyObject]!, error: NSError!) -> Void in
            let placemark = objects.first as CLPlacemark
            self.location = placemark.name
        })
    }
    
    //this should be called every time
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .Authorized || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            // ...
        }
    }
    
    //MARK: - diary entry management
    
    func insertDiaryEntry() {
        let coreDataStack = CoreDataStack.defaultStack
        
        var entry: DiaryEntry = NSEntityDescription.insertNewObjectForEntityForName("DiaryEntry", inManagedObjectContext: coreDataStack.managedObjectContext!) as DiaryEntry
        
        entry.body  = self.textView.text
        entry.date = NSDate().timeIntervalSince1970
        entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75)
        entry.mood = self.pickedMood!.rawValue
        println("located at \(self.location)")
        entry.location = self.location
        coreDataStack.saveContext()
        
        
    }
    
    func updateDiaryEntry() {
        self.entry?.body = self.textView.text
        self.entry?.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75)
        self.entry?.mood = self.pickedMood!.rawValue
        //self.entry?.location = ""

        let coreDataStack = CoreDataStack.defaultStack

        coreDataStack.saveContext()
        
    }
    
    //MARK: - functions for camera, including delegate
    
    func promptForSource() {
        
        let actionController = UIAlertController(title: "Image Source", message: "Select an image source", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .Default) { (action: UIAlertAction!) -> Void in
            self.promptForCamera()
        }
        let photoRollButton = UIAlertAction(title: "Photo Roll", style: .Default) { (action: UIAlertAction!) -> Void in
            self.promptForPhotoRoll()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionController.addAction(cameraButton)
        actionController.addAction(photoRollButton)
        actionController.addAction(cancelButton)

        
        self.presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    func promptForCamera() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
        self.imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera)!
        self.imagePicker!.allowsEditing = false
        self.imagePicker!.delegate = self
        self.presentViewController(self.imagePicker!, animated: true, completion: nil)
    }
    
    func promptForPhotoRoll() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.imagePicker!.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(self.imagePicker!.sourceType)!
        self.imagePicker!.allowsEditing = false
        self.imagePicker!.delegate = self
        self.presentViewController(self.imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        
        var mediaType: String = info[UIImagePickerControllerMediaType] as String
        
        if (mediaType == kUTTypeImage) {
            //a photo was taken or selected
            println("media type was found")
            let image = (info[UIImagePickerControllerOriginalImage] as UIImage)
            self.pickedImage = image
            }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func setPickedMood(pickedMood: DiaryEntry.DiaryEntryMood) { //update this later to implement getter/setter override using newValue
        self.pickedMood = pickedMood
        
        
        self.badButton.alpha = 0.5
        self.goodButton.alpha = 0.5
        self.averageButton.alpha = 0.5
        
        switch (pickedMood) {
        case .DiaryEntryMoodGood:
            self.goodButton.alpha = 1.0
        case .DiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0
        case .DiaryEntryMoodBad:
            self.badButton.alpha = 1.0
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func doneWasPressed(sender: AnyObject) {
        if (self.entry != nil) {
            self.updateDiaryEntry()
        }else {
            self.insertDiaryEntry()
        }
        self.dismissSelf()

    }

    @IBAction func cancelWasPressed(sender: AnyObject) {
        self.dismissSelf()
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func badWasPressed(sender: AnyObject) {
        self.setPickedMood(DiaryEntry.DiaryEntryMood.DiaryEntryMoodBad)

    }
    
    @IBAction func averageWasPressed(sender: AnyObject) {
        self.setPickedMood(DiaryEntry.DiaryEntryMood.DiaryEntryMoodAverage)

    }
    
    @IBAction func goodWasPressed(sender: AnyObject) {
        self.setPickedMood(DiaryEntry.DiaryEntryMood.DiaryEntryMoodGood)

    }
    @IBAction func imageButtonWasPressed(sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            self.promptForSource()
        } else {
            self.promptForPhotoRoll()
        }
    }
    
}
