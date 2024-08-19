

import UIKit

class AddNewTripViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var todoTextView: UITextView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .black
        startDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
        
        tripNameTextField.delegate = self
        originTextField.delegate = self
        destinationTextField.delegate = self
        todoTextView.delegate = self
    }
    
    @IBAction func resetDidTapped(_ sender: UIButton) {
        resetAllData()
    }
    
    @IBAction func addDidTapped(_ sender: UIButton) {
        
        if todoTextView.text?.isEmpty == true || tripNameTextField.text?.isEmpty == true || destinationTextField.text?.isEmpty == true || originTextField.text?.isEmpty == true {
            warningLabel.isHidden = false
            return
        }
        
        addTrip()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        warningLabel.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        warningLabel.isHidden = true
    }
    
    func resetAllData() {
        tripNameTextField.text = ""
        destinationTextField.text = ""
        originTextField.text = ""
        todoTextView.text = ""
        warningLabel.isHidden = true
    }
    
    func addTrip() {
        let tripName = tripNameTextField.text ?? ""
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        let origin = originTextField.text ?? ""
        let destination = destinationTextField.text ?? ""
        let thingsToDo = todoTextView.text ?? ""
        
        if startDate > endDate {
            self.showAlert(title: "Error", message: "Verify entered start date and end date!")
            return
        }
        
        let trip = TripModel(title: tripName, originLocation: origin, destination: destination, startDate: startDate, endDate: endDate, toDoList: thingsToDo)
        
        CoreData.shared.addANewTrip(trip: trip) { success in
            if success {
                self.showAlert(title: "Trip Added", message: "You successfully added new Trip")
                self.resetAllData()
            } else {
                self.showAlert(title: "Failed to add Trip", message: "Operation failed when adding new Trip")   
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
}
