//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Vincent Ratford on 2/19/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [todoeyItems]()
  
//    let defaults = UserDefaults.standard  // Access standard user defaults
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        loadItems()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    

    

    //MARK: - Tableview Datsource Methods, Configure tableView with numberOfRowsInSection and populate with itemArray.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count  // return the items in ItemArray
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.itemName
        
        // Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        

        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print(itemArray[indexPath.row])
        
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
            
            let newItem = todoeyItems()
            newItem.itemName = textField.text!
            
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
    let encoder = PropertyListEncoder()
    
    do {
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
    } catch {
        print("Error encoding item array, \(error)")
    }
    
    self.tableView.reloadData()
    }
    
    func loadItems () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                  itemArray = try decoder.decode([todoeyItems].self, from: data)
            } catch {
                 print("Error decoding item array, \(error)")
            }
          
        }
        
    }

}


