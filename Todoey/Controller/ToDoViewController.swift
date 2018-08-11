//
//  ViewController.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/8/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getItemOrLoadItem()
        
        
       // Get the local data from "ToDoList" and store into item
//
//        if let item = defaults.array(forKey: "ToDoList") as? [Item]{
//            itemArray = item
//        }

       
    }
    //MARK - TableView datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.title
        
       
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        
        
        
        return cell
    }
    
    //MARK - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
        
        
        //tableView.reloadData()
        
        
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItem()
            
         
        }
        alert.addAction(action)
        
        
        alert.addTextField { (alertTextield) in
            alertTextield.placeholder = "Create new itwm"
            
            textField = alertTextield
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK - A function that save our item into filePath and reload out tableView
    
    func saveItem () {
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataPath!)
        }
        catch{
            print("Error in encoding \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK - Get back data from dataPath
    
    func getItemOrLoadItem(){
        
       if let data = try? Data(contentsOf: dataPath!){
            let decoder = PropertyListDecoder()
            do{
        
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error in decoding data \(error)")
            }
        }
   
        
    }
}








