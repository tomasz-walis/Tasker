//
//  AddTask.swift
//  CwTasker
//
//  Created by Tomasz Walis-Walisiak on 06/05/2018.
//  Copyright © 2018 Tomasz Walis-Walisiak. All rights reserved.
//

import UIKit
import CoreData
class AddTask: UIViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var txtNewTask: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        let newTask = Task(context: context)
        newTask.taskName = txtNewTask.text
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print(newTask)
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
