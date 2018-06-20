//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Josh Davis on 6/17/18.
//  Copyright © 2018 Josh Davis. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        loadCategoryItems()
    }

    //MARK: TableView Datasource Methods (Set what happens when tableview initially loads, # of cells + what's in them)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories"
        
        return cell
    }
    
    //MARK: TableView Delegate Methods (Set what happens when tableview cells are touched)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    //MARK: Data Manipulation Methods (Set read and write methods to save data to persistent storage)
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving category context. Error \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategoryItems() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch {
                print("Error deleting category. \(error)")
            }
            
        }
        
    }
    
    //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategoryItem = Category()
            
            newCategoryItem.name = alertTextField.text!
            
            self.save(category: newCategoryItem)
            
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "New Category Name"
            alertTextField = textfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
