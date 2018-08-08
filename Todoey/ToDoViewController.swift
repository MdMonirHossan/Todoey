//
//  ViewController.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/8/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var itemArray = ["First work" , "Sccond work" , "Third work"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    //MARK - TableView datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    //MARK - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
       
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextield) in
            alertTextield.placeholder = "Create new itwm"
            
            textField = alertTextield
        }
        present(alert, animated: true, completion: nil)
    }
}








