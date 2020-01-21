//
//  AddTaskTableViewController.swift
//  Sumandeep_c0764942
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class AddTaskTableViewController: UITableViewController {
    var AddTasks: [Taskinfo]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCoreData()
    }
    
    func loadCoreData() {
           AddTasks = [Taskinfo]()
           // create an instance of app delegate
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           // second step is context
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
           
           do {
               let task = try managedContext.fetch(fetchRequest)
               if task is [NSManagedObject] {
                   for taskres in task as! [NSManagedObject] {
                       let taskname = taskres.value(forKey: "name") as! String
                       
                       AddTasks?.append(Taskinfo(name: taskname))
                    tableView.reloadData()
                   
                   }
               }
           } catch {
               print(error)
           }
           
       }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AddTasks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let task = AddTasks![indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellAdd")
            
       
                cell?.textLabel?.text = task.name

        // Configure the cell...

        return cell!
    }
    
    func updateTask(taskArray: [Taskinfo]){
        AddTasks = taskArray
        tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailView = segue.destination as? TaskViewController {
            detailView.TaskTable = self
            detailView.AddTasks = AddTasks
        }
    }
    

}
