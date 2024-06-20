import UIKit

class AddEmployeeViewController: UIViewController {

    var employeeData: [String: Any]?

    init(employeeData: [String: Any]? = nil) {
        self.employeeData = employeeData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tableView: UITableView!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var salaryTextField: UITextField!
    var empIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = employeeData == nil ? "Add Employee" : "Edit Employee"
        setupTableView()
        setupNavigationBar()
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let employeeData = employeeData {
            populateForm(with: employeeData)
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag // Dismiss keyboard when scrolling
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: "FormCell")
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func populateForm(with data: [String: Any]) {
        if let name = data["name"] as? String {
            nameTextField.text = name
        }
        if let email = data["email"] as? String {
            emailTextField.text = email
        }
        if let salary = data["salary"] as? Double {
            salaryTextField.text = "\(salary)"
        }
        if let empId = data["empId"] as? Int64 {
            empIdTextField.text = "\(empId)"
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let salaryText = salaryTextField.text,
              let salary = Double(salaryText),
              let empIdText = empIdTextField.text,
              let empId = Int64(empIdText) else {
            return
        }
        
        if employeeData == nil {
            DBManager.shared.addData(name: name, empId: empId, email: email, salary: salary)
        } else {
            let newValues: [String: Any] = ["name": name, "email": email, "salary": salary, "empId": empId]
            DBManager.shared.updateData(empId: empId, newValues: newValues)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddEmployeeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.configure(title: "Name", placeholder: "Enter name")
            nameTextField = cell.inputTextField
        case 1:
            cell.configure(title: "Email", placeholder: "Enter email")
            emailTextField = cell.inputTextField
        case 2:
            cell.configure(title: "Salary", placeholder: "Enter salary", keyboardType: .decimalPad)
            salaryTextField = cell.inputTextField
        case 3:
            cell.configure(title: "Employee ID", placeholder: "Enter ID", keyboardType: .numberPad)
            empIdTextField = cell.inputTextField
        default:
            break
        }
        
        return cell
    }
}
