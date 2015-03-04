//
//  EntryListViewController.swift
//  Diary
//
//  Created by Tim Walsh on 3/3/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit
import CoreData

class EntryListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var theFetchedResultsController: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.fetchedResultsController.performFetch(nil)
    
        //self.theFetchedResultsController!.performFetch(nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.theFetchedResultsController!.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo =  self.theFetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let entry = self.fetchedResultsController.objectAtIndexPath(indexPath) as DiaryEntry
        cell.textLabel?.text = entry.body

        return cell
    }
    
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.theFetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
        
        return sectionInfo.name
    }

    //MARK: - fetch requests and controllers
    
    func entryListFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "DiaryEntry") //create the fetch request for the entity we want
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] //set the array of sort descriptors (in this case it is sorted by date)
        
        return fetchRequest
    }
    
    
    
    
    
    var fetchedResultsController: NSFetchedResultsController {//override the getter of theFetchedResultsController with fetchedResultsController
        get{
            if (self.theFetchedResultsController != nil) {
                return self.theFetchedResultsController!
            }
        
            let coreDataStack = CoreDataStack.defaultStack
            var fetchRequest = self.entryListFetchRequest()
            
            self.theFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedObjectContext!, sectionNameKeyPath: "sectionName", cacheName: nil)
            self.fetchedResultsController.delegate = self
            
            return self.theFetchedResultsController!
            }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {//starts making the changes to the tableView
        self.tableView.beginUpdates()
    }
    
    //preps any thing that did change
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {//this should not be passing optionals!!!!
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            return
        }
    }
    
    //this is called when a section is either created or deleted (or changed I guess)
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            return
            
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) { //finishes updating the tableview after changes
        self.tableView.endUpdates()
        //self.tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            var entry = self.fetchedResultsController.objectAtIndexPath(indexPath) as DiaryEntry
            var coreDataStack = CoreDataStack.defaultStack as CoreDataStack
            coreDataStack.managedObjectContext!.deleteObject(entry)
            coreDataStack.saveContext()
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
