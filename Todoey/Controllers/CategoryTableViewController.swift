//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Josh Davis on 6/17/18.
//  Copyright © 2018 Josh Davis. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryItems()
    }

    //MARK: TableView Datasource Methods (Set what happens when tableview initially loads, # of cells + what's in them)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: TableView Delegate Methods (Set what happens when tableview cells are touched)
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }else{
            print("Error")
        }
        
    }
    
    
    //MARK: Data Manipulation Methods (Set read and write methods to save data to persistent storage)
    
    func saveCategoryItems() {
        
        do {
            try context.save()
        }catch{
            print("Error saving category context. Error \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategoryItems() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch{
            print("Error fetching categories. Error \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "New Category", style: .default) { (action) in
            
            let newCategoryItem = Category(context: self.context)
            
            newCategoryItem.name = alertTextField.text!
            
            self.categoryArray.append(newCategoryItem)
            
            self.saveCategoryItems()
            
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "New Category Name"
            alertTextField = textfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
