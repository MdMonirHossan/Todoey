//
//  ItemsTableViewController.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/17/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController {

    var catagories = [Catagory]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCatagories()
    }
    
    //MARK: - Table View data source methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return  catagories.count
    }
    
    
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = catagories[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Todoitem", for: indexPath)
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    //MARK: - Table view delegate method

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "toDoItem", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController

        if let indexpath = tableView.indexPathForSelectedRow {

            destinationVC.selectedcatagory = catagories[indexpath.row]
        }
    }
    
    //MARK: - Add item method
    
    
       @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        
          var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCatagory = Catagory(context: self.context)
            newCatagory.name = textField.text!
           self.catagories.append(newCatagory)
             self.saveCatagories()
            
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Catagory"
            textField = alertTextField
           
        }
        
       present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation methods
    
    
    func saveCatagories () {
        
        do{
            try context.save()
        }
        catch{
            print("Error in saving data , \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func loadCatagories (with request : NSFetchRequest<Catagory> = Catagory.fetchRequest()){
        
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
        do{
            catagories = try context.fetch(request)
        }catch{
            print("Fatching data from persistentContainer \(error)")
        }
        tableView.reloadData()
    }
}
