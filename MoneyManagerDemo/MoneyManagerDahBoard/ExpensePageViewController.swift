//
//  ExpensePageViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 15/11/21.
//

import UIKit
import CoreData

class ExpensePageViewController: UIViewController{

    @IBOutlet var ExpenseTableVIew: UITableView!
    var expensesArray: [User] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard

    var username:String?
    var currentUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = defaults.string(forKey: "username")

        ExpenseTableVIew.dataSource=self
        fetchPeople()
        fetchCurrentUser()
    }
    func fetchCurrentUser(){
        if let foo = expensesArray.first(where: {$0.usename == username}) {
           // do something with foo
            currentUser=foo
        } else {
           // item could not be found
        }
    }
    func fetchPeople(){
        //fetch data from core data to display in the table view
        do{
            try self.expensesArray =  context.fetch(User.fetchRequest())
        }catch{
        }
        DispatchQueue.main.async {
            self.ExpenseTableVIew.reloadData()
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
             
             self.currentUser?.expenses?.append(expenseToSave)
             do{
                 try self.context.save()
             }catch{
                 
             }
             self.fetchPeople()
         }
         let cancelAction = UIAlertAction(title: "Cancel",
                                          style: .cancel)
         alert.addTextField()
         alert.addAction(saveAction)
         alert.addAction(cancelAction)
         present(alert, animated: true)
    }
    
    @IBAction func didTapRemoveAll(_ sender: Any) {
        self.currentUser?.expenses?.removeAll()
        do{
            try self.context.save()
        }catch{
            
        }
        self.fetchPeople()
 
    }
    
}
extension ExpensePageViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell =
             tableView.dequeueReusableCell(withIdentifier: "cell",
                                           for: indexPath)
        cell.textLabel?.text = currentUser?.expenses?[indexPath.row]
           return cell
        
    }
    
    
}
