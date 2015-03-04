//
//  EntryViewController.swift
//  Diary
//
//  Created by Tim Walsh on 3/3/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit
import CoreData


class EntryViewController: UIViewController {
    

    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func insertDiaryEntry() {
        let coreDataStack = CoreDataStack.defaultStack
        
        var entry: DiaryEntry = NSEntityDescription.insertNewObjectForEntityForName("DiaryEntry", inManagedObjectContext: coreDataStack.managedObjectContext!) as DiaryEntry
        
        entry.body  = self.textField.text
        entry.date = NSDate().timeIntervalSince1970
        coreDataStack.saveContext()
        
        
    }
    
    @IBAction func doneWasPressed(sender: AnyObject) {
        self.insertDiaryEntry()
        self.dismissSelf()
    }

    @IBAction func cancelWasPressed(sender: AnyObject) {
        self.dismissSelf()
    }
    
    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
