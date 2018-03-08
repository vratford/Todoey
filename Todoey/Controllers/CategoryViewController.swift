//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vincent Ratford on 3/5/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
        
    }


    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count  // return the Categories in categoryArray
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row] //not needed ?
        
//        cell.addGestureRecognizer(longPressRecognizer)
        
        cell.textLabel?.text = category.name
        
        return cell
    }
  
    //MARK: - TableView Delegate Methods

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories (with request: NSFetchRequest<Category> = Category.fetchRequest()) { //Category.fetchRquest is the default state for this parameter request
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
        
    }
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        // what will happen once the user clicks the Add Category button on our UIAlert
        
        
        let newCategory = Category(context: self.context) // saves new category and insert into context
        newCategory.name = textField.text!
        self.categoryArray.append(newCategory)  // if field is nil then go on !
        
        self.saveCategories()
        
    }
    
    
    alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create new Category"
        textField = alertTextField
    
    
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  
}


}

