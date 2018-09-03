//
//  ItemsTableViewController.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/17/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ItemsTableViewController: UITableViewController {
    
    let realm = try! Realm()

    var catagories : Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCatagories()
    }
    
    //MARK: - Table View data source methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return  catagories?.count ?? 1
    }
    
    
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = catagories?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todoitem", for: indexPath)
        cell.textLabel?.text = item?.name ?? "No category added yet"
        
        return cell
    }
    
    //MARK: - Table view delegate method

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "toDoItem", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController

        if let indexpath = tableView.indexPathForSelectedRow {

            destinationVC.selectedcatagory = catagories?[indexpath.row]
        }
    }
    
    //MARK: - Add item method
    
    
       @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
          var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCatagory = Category()
            newCatagory.name = textField.text!
            
            self.saveCatagories(category: newCatagory )
            
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Catagory"
            textField = alertTextField
           
        }
        
       present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation methods
    
    
    func saveCatagories (category : Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error in saving data , \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func loadCatagories (){
        
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        catagories = realm.objects(Category.self)

        tableView.reloadData()
    }
}
