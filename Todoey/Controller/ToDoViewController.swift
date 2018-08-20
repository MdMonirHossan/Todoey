//
//  ViewController.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/8/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import UIKit
import CoreData


class ToDoViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedcatagory : Catagory? {
        
        didSet{
           getItemOrLoadItem()
        }
    }
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
       // Get the local data from "ToDoList" and store into item
//
//        if let item = defaults.array(forKey: "ToDoList") as? [Item]{
//            itemArray = item
//        }

       
    }
    //MARK: - TableView datasource method
    
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
    
    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
    
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
        
        
        //tableView.reloadData()
        
        
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
        
           let newItem = Item(context: self.context )
            newItem.done = false
            newItem.parentCatagory = self.selectedcatagory
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItem()
            
         
        }
        alert.addAction(action)
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - A function that save our item into filePath and reload out tableView
    
    func saveItem () {
        
        do{
           try context.save()
        }
        catch{
            print("Error in saving data , \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: - Get back data from dataPath
    
    func getItemOrLoadItem(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil){

       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let catagoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedcatagory!.name!)
        
        if let additionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagoryPredicate , additionalPredicate])
        } else {
            request.predicate  = catagoryPredicate
        }
        
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Fatching data from persistentContainer \(error)")
        }
        tableView.reloadData()
    }
}

 extension ToDoViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       getItemOrLoadItem(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            
            getItemOrLoadItem()
            
            DispatchQueue.main.async {
             
                searchBar.resignFirstResponder()
            }
           
        }
    }
}








