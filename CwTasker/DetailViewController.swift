//
//  DetailViewController.swift
//  MasterDetailV2
//
//  Created by Philip Trwoga on 27/03/2018.
//  Copyright © 2018 Philip Trwoga. All rights reserved.
//

// if you use any of this code make sure you reference it

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchRequest: NSFetchRequest<Task>!
    //var albums: [Task]!

    func configureView() {
        // Update the user interface for the detail item.
     //   self.tableView.delegate = self
     //   self.tableView.dataSource = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //topView.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "topCw" {
            //topView.isHidden = false
            
            if let topViewController = segue.destination as? TopCourseworkViewController{
                //topView.isHidden = false
                print("Show Here")
                topViewController.moduleName = coursework?.moduleName
                topViewController.level = coursework?.level
                topViewController.weight = coursework?.weight
                topViewController.mark = coursework?.mark
                topViewController.courseworkNotes = coursework?.notes
                
            }
        }
        if segue.identifier == "addTask"
        {
            if let addAlbumViewController = segue.destination as? AddTaskViewController{
                addAlbumViewController.currentCoursework = coursework
            }
        }
    }

    var coursework: Coursework? {
        didSet {
            // Update the view.
            configureView()
        }
    }

         // MARK: - tableView delegate section
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
        self.configureCell(cell,indexPath: indexPath)
        return cell
    }
    
     func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
     //   cell.detailTextLabel?.text = "test label"
        
        let title = self.fetchedResultsController.fetchedObjects?[indexPath.row].taskName
        cell.textLabel!.text = title
        //if let genreText = self.fetchedResultsController.fetchedObjects?[indexPath.row].genre
       // {
        //    cell.detailTextLabel?.text = genreText
       // }
       // else {
          //  cell.detailTextLabel!.text = ""
       // }
        
    }
   
    //MARK: - fetch results controller
    
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        
        let currentCoursework = self.coursework
        let request:NSFetchRequest<Task> = Task.fetchRequest()
        //simpler version for just getting the albums
        //   let albums:NSSet = (currentArtist?.albums)!
        
        request.fetchBatchSize = 20
        //sort alphabetically
        let albumNameSortDescriptor = NSSortDescriptor(key: "taskName", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        //simpler version
        //   albums.sortedArray(using: [albumNameSortDescriptor])
        
        
        request.sortDescriptors = [albumNameSortDescriptor]
        //we want the albums for the recordArtist - via the relationship
        if(self.coursework != nil){
            let predicate = NSPredicate(format: "courseworkTask = %@", currentCoursework!)
            request.predicate = predicate
        }
        else {
            //just do all albums for the first artist in the list
            //replace this to get the first artist in the record
            let predicate = NSPredicate(format: "taskName = %@","checkCoursework")
            request.predicate = predicate
            
            
        }
        
        let frc = NSFetchedResultsController<Task>(
            fetchRequest: request,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: #keyPath(Task.taskName),
            cacheName:nil)
        frc.delegate = self
        _fetchedResultsController = frc
        
        do {
            //    try frc.performFetch()
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
        return frc as! NSFetchedResultsController<NSFetchRequestResult> as! NSFetchedResultsController<Task>
    }//end var
    
      //MARK: - fetch results table view functions

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    //must have a NSFetchedResultsController to work
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType(rawValue: 0)!:
            // iOS 8 bug - Do nothing if we get an invalid change type.
            break
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, indexPath: newIndexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            //    default: break
            
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        // self.tableView.reloadData()
    }


}

