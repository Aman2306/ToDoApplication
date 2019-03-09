//
//  AllTasks ViewController.swift
//  ToDoApplication
//
//  Created by Aman Meena on 08/03/19.
//  Copyright © 2019 Aman Meena. All rights reserved.
//

import UIKit
import CoreData

class AllTasksViewController: UITableViewController {

    // MARK: Outlets
    @IBOutlet var allTasksTableView: UITableView!
    
    // MARK: Variables
    var resultsController: NSFetchedResultsController<Todo>!
    
    // MARK: Constants
    let cellID = "ToDoCell"
    let segueID = "ShowAddToDo"
    let coreDataStack = CoreDataStack()
    
    // MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Request
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        // Init
        request.sortDescriptors = [sortDescriptor]
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.manageContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        // Fetch
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
        
        // TODO: write in copy and mention to write in end
        resultsController.delegate = self
    }
    
    // MARK: Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = allTasksTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let todo  = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title // creates label if doesn't already exist
//        lbl.text = todo.title
        return cell
    }
    
    // MARK: Table view delegate methods
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // TODO: write in copy
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            
            // this is very important to save context after deleting, otherwise changes will be transient
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("deletion failed: \(error)")
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action] )
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            // TODO: done todo
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            
            // this is very important to save context after deleting, otherwise changes will be transient
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("deletion failed: \(error)")
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "check")
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action] )
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueID, sender: tableView.cellForRow(at: indexPath)) // on writing self the app crashes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? NewTaskViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
        
        // write in copy
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? NewTaskViewController {
            vc.managedContext = resultsController.managedObjectContext
            
            if let indexPath = allTasksTableView.indexPath(for: cell) {
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
    }
    
}

// TODO: write in copy
extension AllTasksViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allTasksTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allTasksTableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                allTasksTableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                allTasksTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.title
            }
        default:
            break
        }
    }
}
