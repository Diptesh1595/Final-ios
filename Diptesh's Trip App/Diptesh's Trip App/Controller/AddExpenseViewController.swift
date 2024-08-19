

import UIKit

class AddExpenseViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var totalExpenseLbl: UILabel!
    
    var trip: TripModel?
    var allExpense: [TripExpenseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .black
        
        tripTitle.text = trip?.title
        
        nameTextField.delegate = self
        amountTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        allExpense = CoreData.shared.fetchAllExpenses(for: trip?.id ?? UUID())
        
        if allExpense.count > 0 {
            totalExpense()
        } else {
            totalExpenseLbl.text = "Total expense: 0"
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        amountTextField.text = ""
        nameTextField.text = ""
        errorLbl.isHidden = true
    }
    
    @IBAction func addExpense() {
        
        if nameTextField.text?.isEmpty == true || amountTextField.text?.isEmpty == true {
            errorLbl.text = "Please fill all the required fields!"
            errorLbl.isHidden = false
            return
        }
    
        guard let amount = Double(amountTextField.text ?? "") else {
            self.showAlert(title: "Error", message: "Please enter a number for the amount field!")
            return
        }
        
        let expense = TripExpenseModel(Id: trip?.id ?? UUID(), title: nameTextField.text ?? "", amount: amount)
        
        CoreData.shared.addNewExpense(expense: expense) { success in
            if success {
                DispatchQueue.main.async { [self] in
                    showAlert(title: "Expense Added", message: "New Expense added successfully into the list")
                    nameTextField.text = ""
                    amountTextField.text = ""
                    allExpense.append(expense)
                    totalExpense()
                    tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async { [self] in
                    self.showAlert(title: "Failed to add expense", message: "Failed to add new expense!")
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLbl.isHidden = true
    }
    
    func totalExpense() {
        var totalExpense: Double = 0
        
        allExpense.forEach { expense in
            totalExpense += expense.amount
        }
        
        errorLbl.isHidden = true
        totalExpenseLbl.text = "Total expense: \(totalExpense)"
    }
}

extension AddExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allExpense.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TripExpenseTableViewCell

        cell.expenseNameLabel.text = allExpense[indexPath.row].title
        cell.expenseAmountLabel.text = "$\(allExpense[indexPath.row].amount)"
        cell.selectionStyle = .none
        
        return cell
    }
}
