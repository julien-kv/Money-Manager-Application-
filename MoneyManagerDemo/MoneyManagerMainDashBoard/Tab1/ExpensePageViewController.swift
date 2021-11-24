//
//  ExpensePageViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 15/11/21.
//

import UIKit
import CoreData
import GoogleSignIn
import FBSDKLoginKit

class ExpensePageViewController: UIViewController{

    @IBOutlet var ExpenseTableVIew: UITableView!
    @IBOutlet var welcomeUsertextLabel: UILabel!
    var expensesArray: [User] = []
    let defaults = UserDefaults.standard

    var username:String?
    var currentUserIndex:Int?
    var expenseViewModel = ExpensePageViewmodel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = defaults.string(forKey: "username")
        defaults.set(true, forKey: "loggedIn")
        welcomeUsertextLabel.text = "Welcome \(username!)"
        ExpenseTableVIew.layer.borderColor = UIColor.blue.cgColor
        ExpenseTableVIew.dataSource=self
        fetchPeople()
        fetchCurrentUser()
    }
   
    @IBAction func didTapAddButton(_ sender: Any) {
        showAddExpenseAlert()
       
    }
    
    @IBAction func didTapRemoveAll(_ sender: Any) {
        expenseViewModel.removeAllExpenses()
        self.fetchPeople()
        
        //Below code is used to test. it will delete all data in coredata
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//
//        // Create Batch Delete Request
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//
//        } catch {
//            // Error Handling
//        }
 
    }
    
    func fetchCurrentUser(){
        expenseViewModel.fetchCurrentUser { userIndex in
            self.currentUserIndex=userIndex
        }
    }
    
    func fetchPeople(){
        expenseViewModel.fetchPeople { array in
            self.expensesArray=array
        }
        
        DispatchQueue.main.async {
            self.ExpenseTableVIew.reloadData()
        }
    }

    
    func showAddExpenseAlert(){
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
             expenseViewModel.addExpensetoList(expenseToSave: expenseToSave)
             
             self.fetchPeople()
             
         }
         let cancelAction = UIAlertAction(title: "Cancel",
                                          style: .cancel)
         alert.addTextField()
         alert.addAction(saveAction)
         alert.addAction(cancelAction)
         present(alert, animated: true)
    }
    
    
}
extension ExpensePageViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return expensesArray[currentUserIndex!].expenses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell =
             tableView.dequeueReusableCell(withIdentifier: "cell",
                                           for: indexPath)
        cell.textLabel?.text = self.expensesArray[currentUserIndex!].expenses?[indexPath.row]
           return cell
        
    }
    
    
}
