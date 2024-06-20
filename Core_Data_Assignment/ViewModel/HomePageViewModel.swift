//
//  HomePageViewModel.swift
//  Core_Data_Assignment
//
//  Created by E5000855 on 20/06/24.
//

import Foundation

class HomepageViewModel {
    
    var employees: [[String: Any]] = []
    
    func fetchData() {
        if let employeeData = DBManager.shared.fetchData() {
            employees = employeeData
        } else {
            // Handle error fetching data
            print("Error fetching employee data.")
        }
    }
    
    func addSampleEmployeeData() {
        DBManager.shared.addData(name: "Sumit", empId: 101, email: "sumit@gmail.com", salary: 123.4)
    }
    func deleteEmployee(at index: Int) {
        let employee = employees[index]
        guard let empId = employee["empId"] as? Int64 else {
            print("Invalid employee data")
            return
        }
        DBManager.shared.deleteData(empId: empId)
        employees.remove(at: index)
    }

}
