//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Vincent Ratford on 2/19/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm ()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadItems()
    }
    

    

    //MARK: - Tableview Datsource Methods, Configure tableView with numberOfRowsInSection and populate with itemArray.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1  // return the items in todoItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
//            cell.addGestureRecognizer(longPressRecognizer)
            
            cell.textLabel?.text = item.title
            
            // Ternary Operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
            
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems? [indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item) // removed delete function to allow done
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
 
            tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Highlights selected item in gray briefly and then returns to white
        
    }
    
     //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
          

            if let currrentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item() // saves new item and insert into Realm
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currrentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item \(error)")
                }
              
            }
            
            
           
            
            self.tableView.reloadData()

        }
        
  
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        

    }

    //MARK: - Model Manipulation Methods

    
    func loadItems () {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()

    }

    //MARK: - Modify existing items in Realm
    @objc func longPress(_ sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            let longPressLocation = sender.location(in: self.tableView)
            if let pressedIndexPath = self.tableView.indexPathForRow(at: longPressLocation) {

                var task = UITextField()
                let alert = UIAlertController(title: "Modify Item", message: "", preferredStyle: .alert)

                let action = UIAlertAction(title: "Modify", style: .default) { (action) in
                    self.todoItems![pressedIndexPath.row].setValue("\(task.text ?? "")", forKey: "title")

//                    if let item = todoItems![pressedIndexPath] {

                            if let currrentCategory = self.selectedCategory {

                                do {
                                    try self.realm.write {
                                    let newItem = Item() // saves new item and insert into Realm
                                    newItem.title = task.text!
                                    newItem.dateCreated = Date()
//                                    currrentCategory.items.append(newItem)
                            }
                        } catch {
                            print("Error saving item \(error)")
                        }

    


                    self.tableView.reloadData()

                }
                alert.addTextField { (alertTextField) in
                    task = alertTextField
                    task.text = "\(self.todoItems![pressedIndexPath.row].title)"
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
     
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
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

