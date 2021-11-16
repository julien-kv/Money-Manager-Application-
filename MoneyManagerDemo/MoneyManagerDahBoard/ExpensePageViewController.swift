//
//  ExpensePageViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 15/11/21.
//

import UIKit
import CoreData

class ExpensePageViewController: UIViewController {

    @IBOutlet var ExpenseTableVIew: UITableView!
    var expensesArray: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExpenseTableVIew.dataSource=self
    }
    var expenseArray:[String] = []
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
      
      //3
      do {
        expensesArray = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "New Expense",
                                       message: "Add a new Expense",
                                       preferredStyle: .alert)
         
         let saveAction = UIAlertAction(title: "Save",
                                        style: .default) {
           [unowned self] action in
                                         
           guard let textField = alert.textFields?.first,
             let expenseToSave = textField.text else {
               return
           }
             self.save(name: expenseToSave)
           self.ExpenseTableVIew.reloadData()
         }
         let cancelAction = UIAlertAction(title: "Cancel",
                                          style: .cancel)
         alert.addTextField()
         alert.addAction(saveAction)
         alert.addAction(cancelAction)
         present(alert, animated: true)
    }
    
    @IBAction func didTapRemoveAll(_ sender: Any) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        // Delete multiple objects
        for object in expensesArray {
            context.delete(object)
        }

        // Save the deletions to the persistent store
        do{
            try context.save()
        }catch{
            print("error")
        }
        expensesArray.removeAll()
        ExpenseTableVIew.reloadData()
        
        
    }
    func save(name: String) {
        
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "User",
                                   in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
        expenseArray=person.value(forKey: "expenses") as! [String]
      person.setValue(name, forKeyPath: "expenses")
      
      // 4
      do {
        try managedContext.save()
          self.expensesArray.append(person)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
}
extension ExpensePageViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = expensesArray[indexPath.row]
           let cell =
             tableView.dequeueReusableCell(withIdentifier: "cell",
                                           for: indexPath)
           cell.textLabel?.text =
             expense.value(forKeyPath: "expenses") as? String
           return cell
        
    }
    
    
}
