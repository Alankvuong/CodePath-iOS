//
//  ViewController.swift
//  Prework - Tip Calculator
//
//  Created by Alan Vuong on 12/31/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var customTipTextField: UITextField!
    @IBOutlet weak var customTipEnterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        billAmountTextField.becomeFirstResponder()
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        // Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        billAmountTextField.resignFirstResponder()
        
        let tipPercentages = [0.15, 0.18, 0.2, 0.0]
        var tip = Double(0.00)
        var total = Double(0.00)
            
        print("Index: ", tipControl.selectedSegmentIndex)
            
            
        // Get Total tip by multiplying tip * percentage
        tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
                                        
        total = bill + tip
        
        // Update Tip Amount Label
        tipAmountLabel.text = String(format: "$%.2f", tip)
        //Update Total Amount
        totalLabel.text = String(format: "$%.2f", total)
        
        customTipTextField.resignFirstResponder()
        customTipTextField.text = ""
    }
    
    @IBAction func calculateCustomTip(_ sender: Any, forEvent event: UIEvent) {
        // Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        billAmountTextField.resignFirstResponder()
        tipControl.selectedSegmentIndex = -1
        var tip = Double(0.00)
        var total = Double(0.00)
        var customTip = Double(0.00)
        
        customTip = Double(customTipTextField.text!) ?? 0
        tip = customTip
        print("Total: ", total)
        
        total = bill + tip
        
        print("Total: ", total)
        
        // Update Tip Amount Label
        tipAmountLabel.text = String(format: "$%.2f", tip)
        //Update Total Amount
        totalLabel.text = String(format: "$%.2f", total)
    }
}

    
