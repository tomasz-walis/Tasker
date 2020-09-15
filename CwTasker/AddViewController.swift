//
//  AddViewController.swift
//  CwTasker
//
//  Created by Tomasz Walis-Walisiak on 05/05/2018.
//  Copyright © 2018 Tomasz Walis-Walisiak. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var txtCwName: UITextField!
    @IBOutlet weak var txtModuleName: UITextField!
    @IBOutlet weak var txtLevel: UITextField!
    @IBOutlet weak var txtDueDate: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var lbMark: UILabel!
    @IBOutlet weak var txtNotes: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCwName.becomeFirstResponder()
        createDatePicker()
    }

    func createDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddViewController.viewTapped(guestureRecognizer:)))
        view.addGestureRecognizer(tap)
        txtDueDate.inputView = datePicker
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDueDate.text = formatter.string(from: datePicker.date)
    }
    
    @objc func viewTapped(guestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
        txtCwName.becomeFirstResponder()
    }
    
    @IBAction func markSlider(_ sender: UISlider) {
        lbMark.text = String(Int(sender.value))
    }

    @IBAction func btSave(_ sender: Any) {
        
        if txtCwName.text != "" {
            let newCoursework = Coursework(context: context)
            newCoursework.name = txtCwName.text
            newCoursework.moduleName = txtModuleName.text
            newCoursework.level = Int16(txtLevel.text!)!
            newCoursework.weight = Int16(txtWeight.text!)!
            newCoursework.dueDate = datePicker?.date
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour,.day]
            formatter.maximumUnitCount = 2
            formatter.unitsStyle = .full
            let diff = formatter.string(from: Date(), to: (datePicker?.date)!) ?? ""
            
            
            newCoursework.daysLeft = diff
            newCoursework.mark = Int16(lbMark.text!)!
            newCoursework.notes = txtNotes.text
     
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            
            
           
            
        }else{
            let alert = UIAlertController(title: "Empty", message: "Fill in CW Name", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        
       
    }
    
    @IBAction func btCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
