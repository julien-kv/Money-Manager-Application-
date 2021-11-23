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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var previousExpense : [String] = []

    var username:String?
    var currentUserIndex:Int?
    
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
    func fetchCurrentUser(){
        if let foo = expensesArray.firstIndex(where: {$0.usename == username}) {
           // do something with foo
            currentUserIndex=foo
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
             previousExpense =  self.expensesArray[currentUserIndex!].expenses ?? []
             previousExpense = previousExpense + [expenseToSave]
             self.expensesArray[currentUserIndex!].expenses = previousExpense
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
        self.expensesArray[currentUserIndex!].expenses?.removeAll()
        do{
            try self.context.save()
        }catch{

        }
        self.fetchPeople()
        
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
    
}
extension ExpensePageViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        GIDSignIn.sharedInstance.signOut()
//        LoginManager().logOut()

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
