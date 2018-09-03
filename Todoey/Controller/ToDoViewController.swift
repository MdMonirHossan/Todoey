//
//  ViewController.swift
//  Todoey
//
//  Created by MD Monir Hossan on 8/8/18.
//  Copyright © 2018 MD Monir Hossan. All rights reserved.
//

import UIKit
import RealmSwift





class ToDoViewController: UITableViewController {

    var toDoItem : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedcatagory : Category? {
        
        didSet{
           getItemOrLoadItem()
        }
    }
    

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
       
        return toDoItem?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItem?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "Item not added yet"
        }
        
         return cell
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        
      
    }
    
    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItem?[indexPath.row]{
            do{
                try realm.write {
                    
                item.done = !item.done
                    //realm.delete(item)
                }
            }
            catch{
                print("Error in saving done status\(error)")
            }
        }
        tableView.reloadData()
        
       // print(itemArray[indexPath.row])
    
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        toDoItem[indexPath.row].done = !toDoItem[indexPath.row].done
//
//        saveItem()
        
        
        //tableView.reloadData()
        
        
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedcatagory{
                do{
                try self.realm.write {
                    
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }catch{
                    print("Erron in saving item \(error)")
                }
                
                self.tableView.reloadData()
            }
            
            
            
//           let newItem = Item(context: self.context )
//            newItem.done = false
//            newItem.parentCatagory = self.selectedcatagory
//
//            self.itemArray.append(newItem)
//
 
        }
        alert.addAction(action)
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - A function that save our item into filePath and reload out tableView
    
    
    
    //MARK: - Get back data from dataPath
    
    func getItemOrLoadItem(){

       toDoItem = selectedcatagory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

 extension ToDoViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItem = toDoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated ", ascending: true)
        
        tableView.reloadData()
        
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//       getItemOrLoadItem(with: request, predicate: predicate)

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




