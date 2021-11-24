//
//  User+CoreDataProperties.swift
//  MoneyManagerDemo
//
//  Created by Julien on 16/11/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var expenses: [String]?
    @NSManaged public var usename: String?

}

extension User : Identifiable {

}
