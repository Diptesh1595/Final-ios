


import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @IBAction func addTrip(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddNewTripViewController") as! AddNewTripViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showList(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

