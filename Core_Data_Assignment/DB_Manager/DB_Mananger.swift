//
//  DBManager.swift
//  Core_Data_Assignment
//
//  Created by E5000855 on 19/06/24.
//

import Foundation
import CoreData
import UIKit

class DBManager {
    static let shared = DBManager()
    
    private init() { }
    
    func addData(name: String, empId: Int64, email: String, salary: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext) else {
            print("Could not find entity description for Employee.")
            return
        }
        
        let employee = NSManagedObject(entity: entity, insertInto: managedContext)
        employee.setValue(name, forKey: "name")
        employee.setValue(empId, forKey: "empId")
        employee.setValue(email, forKey: "email")
        employee.setValue(salary, forKey: "salary")
        
        do {
            try managedContext.save()
            print("Successfully saved data.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchData() -> [[String: Any]]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        
        do {
            let employees = try managedContext.fetch(fetchRequest)
            
            // Convert NSManagedObject array to array of dictionaries
            var employeeData: [[String: Any]] = []
            for employee in employees {
                var data: [String: Any] = [:]
                data["name"] = employee.value(forKey: "name") as? String
                data["empId"] = employee.value(forKey: "empId") as? Int64
                data["email"] = employee.value(forKey: "email") as? String
                data["salary"] = employee.value(forKey: "salary") as? Double
                employeeData.append(data)
            }
            
            return employeeData
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }


    func updateData(object: NSManagedObject, newValues: [String: Any]) {
        for (key, value) in newValues {
            object.setValue(value, forKey: key)
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            print("Successfully updated data.")
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    func deleteData(object: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            print("Successfully deleted data.")
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
    func updateData(empId: Int64, newValues: [String: Any]) {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               print("Could not retrieve AppDelegate.")
               return
           }
           
           let managedContext = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
           fetchRequest.predicate = NSPredicate(format: "empId == %lld", empId)
           
           do {
               let results = try managedContext.fetch(fetchRequest)
               if let employee = results.first as? NSManagedObject {
                   employee.setValue(newValues["name"], forKey: "name")
                   employee.setValue(newValues["email"], forKey: "email")
                   employee.setValue(newValues["salary"], forKey: "salary")
                   employee.setValue(newValues["empId"], forKey: "empId")
                   
                   try managedContext.save()
                   print("Successfully updated employee with empId \(empId).")
               } else {
                   print("Employee with empId \(empId) not found.")
               }
           } catch let error as NSError {
               print("Could not update. \(error), \(error.userInfo)")
           }
       }
    
    func deleteData(empId: Int64) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        fetchRequest.predicate = NSPredicate(format: "empId == %lld", empId)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let employee = results.first as? NSManagedObject {
                managedContext.delete(employee)
                try managedContext.save()
                print("Successfully deleted employee with empId \(empId).")
            } else {
                print("Employee with empId \(empId) not found.")
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    func clearData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            print("Successfully cleared data.")
        } catch let error as NSError {
            print("Could not clear data. \(error), \(error.userInfo)")
        }
    }


}
