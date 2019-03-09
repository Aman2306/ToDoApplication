//
//  NewTaskViewController.swift
//  ToDoApplication
//
//  Created by Aman Meena on 08/03/19.
//  Copyright © 2019 Aman Meena. All rights reserved.
//

import UIKit
import CoreData

class NewTaskViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var prioritySelector: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
//     ----------------------------- ----------------------------- -----------------------------
    @IBOutlet weak var bottomContraint: NSLayoutConstraint! // add this to bottom layout
//     ----------------------------- ----------------------------- -----------------------------
    
    // MARK: Variables
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    // MARK: Constants
    
    // MARK: Actions
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismissAndResign()
    }
   
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        
        guard let title = taskTextView.text else {
            let alertController = UIAlertController(title: "No Title", message: "Please give a task title", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            return
        }
        
        if let todo = self.todo {
            todo.title = title
            todo.title = title
            todo.priority = Int16(prioritySelector.selectedSegmentIndex)
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(prioritySelector.selectedSegmentIndex)
            todo.date = Date()
        }
        
        
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            print("error saving todo: \(error)")
        }
    }
    
    // this is the implementation of objective-c code -----------------------------
    @objc func keyboardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[ key ] as? NSValue else {return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 8
        
        bottomContraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        //  ---------------------------------------------------------------------------------------
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true, completion: nil)
        taskTextView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isHidden = true
        
        // begins from here -----------------------------------------
        // Do additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with: )),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        // ends here -----------------------------------------
        
        taskTextView.isEditable = true
//        taskTextView.is
        taskTextView.becomeFirstResponder()
        
        
        if let todo = todo {
            taskTextView.text = todo.title
            prioritySelector.selectedSegmentIndex = Int(todo.priority)
        }
    }
    
    
}

extension NewTaskViewController: UITextViewDelegate {
    
//    func textViewDidChange(_ textView: UITextView) {
////        textView.text.removeAll()
//        textView.textColor = .white
//
//        doneButton.isHidden = false
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.textColor = .white

        doneButton.isHidden = false

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        textView.text.removeAll()
//        textView.textColor = .white
////        textView.text.removeAll()
//
//        doneButton.isHidden = false
//
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
}
