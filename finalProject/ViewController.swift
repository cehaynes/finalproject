//
//  ViewController.swift
//  finalProject
//
//  Created by Apple on 6/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.title = "To-Dos & Goals"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButtom(_:)))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
        do {
            self.todoItems = try [ToDoItem] .readFromPersistance()
        }
        catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistance file found, not necessarily an error...")
            }
            else {
                let alert = UIAlertController(
                    title: "Error", message: "Could not load the to-do items", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                NSLog("Error loading from persistance: \(error)")
            }
        }
    }

    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification) {
        
        do {
            try todoItems.writeToPersistance()
        }
        catch let error {
            NSLog("Error writing to persistance: \(error)")
        }
    }
    
    private var todoItems = [ToDoItem]()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
        
        if indexPath.row < todoItems.count {
            let item = todoItems[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCell.AccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
       return cell
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < todoItems.count {
            let item = todoItems[indexPath.row]
            item.done = !item.done
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func didTapAddItemButtom(_ sender: UIBarButtonItem) {
        
        //create an alert
        let alert = UIAlertController(title: "New item", message: "Insert title of the new item:", preferredStyle: .alert)
        
        //add a text field to the alert for the new item's title
        alert.addTextField(configurationHandler: nil)
        
        //add a cancel button to the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        //add a ok button to the alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
            if let title = alert.textFields?[0].text {
                self.addNewToDoItem(title: title)
            }
        }))
        
        //present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addNewToDoItem(title: String) {
        
        //create new item and add it to current item count
        let newIndex = todoItems.count
        
        //create a new item and add it to the list
        todoItems.append(ToDoItem(title: title))
        
        //tell the table view  new row has been created
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row < todoItems.count {
            
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    

    
}
