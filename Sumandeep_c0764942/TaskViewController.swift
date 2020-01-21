//
//  TaskViewController.swift
//  Sumandeep_c0764942
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {

    var AddTasks:[Taskinfo]?
    var TaskTable:AddTaskTableViewController?
    
    @IBOutlet weak var taskTextfld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    saveCoreData()
        NotificationCenter.default.addObserver(self,selector: #selector(saveCoreData),name: UIApplication.willResignActiveNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func getFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if documentPath.count > 0 {
            let documentDirectory = documentPath[0]
            let filePath = documentDirectory.appending("/task.txt")
            return filePath
        }
        return ""
    }
    
    
    @IBAction func addTasks(_ sender: UIButton) {
        
        let name = taskTextfld.text ?? ""
        let task = Taskinfo(name: name)
        AddTasks?.append(task)
        taskTextfld.text = ""
        taskTextfld.resignFirstResponder()
    }
    
    
    @objc func saveCoreData() {
           // call clear core data
         //  clearCoreData()
           // create an instance of app delegate
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           // second step is context
           let managedContext = appDelegate.persistentContainer.viewContext
           
           for task in AddTasks! {
               let taskEntity = NSEntityDescription.insertNewObject(forEntityName: "TaskEntity", into: managedContext)
               taskEntity.setValue(task.name, forKey: "name")
             
               
               // save context
               do {
                   try managedContext.save()
               } catch {
                   print(error)
               }
           }
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
                    let name = taskres.value(forKey: "name") as! String
                    
                    AddTasks?.append(Taskinfo(name: name))
                
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    func clearCoreData() {
        // create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // second step is context
        let managedContext = appDelegate.persistentContainer.viewContext
        // create a fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObjects in results {
                if let managedObjectData = managedObjects as? NSManagedObject {
                    managedContext.delete(managedObjectData)
                }
            }
        } catch {
            print(error)
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        TaskTable?.updateTask(taskArray: AddTasks!)
    }
    

}
