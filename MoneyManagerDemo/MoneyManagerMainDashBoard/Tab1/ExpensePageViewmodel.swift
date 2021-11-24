//
//  ExpensePageViewmodel.swift
//  MoneyManagerDemo
//
//  Created by Julien on 24/11/21.
//

import Foundation
import UIKit
import CoreData
import GoogleSignIn
import FBSDKLoginKit

class ExpensePageViewmodel{
    
    var expensesArray: [User] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var previousExpense : [String] = []
    var username:String?
    var currentUserIndex:Int?
    
    func fetchCurrentUser( indextocaller: (Int?)->() ){
        username = defaults.string(forKey: "username")
        if let foo = expensesArray.firstIndex(where: {$0.usename == username}) {
           // do something with foo
            currentUserIndex=foo
            indextocaller(foo)
        } else {
           // item could not be found
        }
    }
    func fetchPeople(arraytoCaller: ([User])->()){
        //fetch data from core data to display in the table view
        do{
            try self.expensesArray =  context.fetch(User.fetchRequest())
            arraytoCaller(expensesArray)
        }catch{
        }
        DispatchQueue.main.async {
            //self.ExpenseTableVIew.reloadData()
        }
    }
    func addExpensetoList(expenseToSave:String){
        previousExpense =  self.expensesArray[currentUserIndex!].expenses ?? []
        previousExpense = previousExpense + [expenseToSave]
        self.expensesArray[currentUserIndex!].expenses = previousExpense
        do{
            try self.context.save()
            
        }catch{
            
        }
    }
    func removeAllExpenses(){
        self.expensesArray[currentUserIndex!].expenses?.removeAll()
        do{
            try self.context.save()
        }catch{

        }
    }
    
   
    
    
    
    
}
