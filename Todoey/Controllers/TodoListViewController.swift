//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Vincent Ratford on 2/19/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        loadItems()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    

    

    //MARK: - Tableview Datsource Methods, Configure tableView with numberOfRowsInSection and populate with itemArray.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count  // return the items in ItemArray
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.addGestureRecognizer(longPressRecognizer)
        
        cell.textLabel?.text = item.title
        
        // Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
 
//        context.delete(itemArray[indexPath.row]) // order of sequence due to array starting at 0 ??
//        itemArray.remove(at: indexPath.row)  // removes item
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // Flip bool state to opposite
    
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) // Highlights selected item in gray briefly and then returns to white
        
    }
    
     //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            
            let newItem = Item(context: self.context) // saves new item and insert into context
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)  // if field is nil then go on !
            
            self.saveItems()
            
        }
            
  
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        

    }

    //MARK: - Model Manipulation Methods

func saveItems() {
    
    do {
        try context.save()
        
    } catch {
        print("Error saving context \(error)")
    }
    
    self.tableView.reloadData()
    }
    
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest()) { //Item.fetchRquest is the default state for this parameter reqquest
        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }

    //MARK: - Updating items in Core Data
    @objc func longPress(_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let longPressLocation = sender.location(in: self.tableView)
            if let pressedIndexPath = self.tableView.indexPathForRow(at: longPressLocation) {
                
                var task = UITextField()
                let alert = UIAlertController(title: "Modify Item", message: "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Modify", style: .default) { (action) in
                    self.itemArray[pressedIndexPath.row].setValue("\(task.text ?? "")", forKey: "title")
                    self.saveItems()
                    
                }
                alert.addTextField { (alertTextField) in
                    task = alertTextField
                    task.text = "\(self.itemArray[pressedIndexPath.row].title!)"
                }
                
                alert.addAction(action)
                
                present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
}
// MARK: - Search Bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            searchBarSearchButtonClicked(searchBar)
        }
    }
}

