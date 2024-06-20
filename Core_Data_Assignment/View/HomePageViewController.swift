//
//  ViewController.swift
//  Core_Data_Assignment
//
//  Created by E5000855 on 19/06/24.
//

import UIKit

class HomepageViewController: UIViewController {

    var tableView: UITableView!
    var viewModel: HomepageViewModel
    var floatingButton: UIButton!

    init(viewModel: HomepageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .white
        title = "All Employee"

        viewModel.addSampleEmployeeData()

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "EmployeeCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        viewModel.fetchData()

        floatingButton = UIButton(type: .custom)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.backgroundColor = UIColor.systemMint
        floatingButton.layer.cornerRadius = 30
        if let plusIcon = UIImage(systemName: "plus")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
            floatingButton.setImage(plusIcon, for: .normal)
        }
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        view.addSubview(floatingButton)

        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func floatingButtonTapped() {
        let addEmployeeVC = AddEmployeeViewController()
        navigationController?.pushViewController(addEmployeeVC, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.fetchData()
        tableView.reloadData()
    }


}
extension HomepageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeTableViewCell
        
        let employee = viewModel.employees[indexPath.row]
        cell.configure(with: employee)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmployee = viewModel.employees[indexPath.row]
        let editEmployeeVC = AddEmployeeViewController(employeeData: selectedEmployee)
        navigationController?.pushViewController(editEmployeeVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let employee = viewModel.employees[indexPath.row]
            if let empId = employee["empId"] as? Int64 {
                DBManager.shared.deleteData(empId: empId)
                viewModel.fetchData()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
