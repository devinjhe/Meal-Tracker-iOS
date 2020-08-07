//
//  MealEditViewController.swift
//  Meal Trakcer
//
//  Created by Devin He on 10/04/2020.
//  Copyright © 2020 Devin He. All rights reserved.
//

import UIKit
import os.log

class MealEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var mealNameTextField: UITextField!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var ratingControl: StarRatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
    // or constructed as part of adding a new meal
    var meal: Meal?
    
    //MARK: Navigation
    
    // This method allows you to configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = mealNameTextField.text ?? ""
        let rating = ratingControl.rating

        // If no photo selected (i.e. remains as default) then set it to "noPhotoSelected" image
        let selectedImageData: Data = (mealImageView.image)!.pngData()!
        let selectPhotoImageData: Data = (UIImage(named: "selectPhoto"))!.pngData()!
        let photo = selectedImageData == selectPhotoImageData ? UIImage(named: "noPhotoSelected") : mealImageView.image
        
        // Configures the meal to be passed after the unwind segue
        meal = Meal(name: name, image: photo, rating: rating)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        // Hide keyboard if needed
        mealNameTextField.resignFirstResponder()
        
        // Create imagePickerController
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        // Notify ViewController when image is selected
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        // Depending on style of presentation (modal or push), this view must be dismissed in different ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController // Add button pressed
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller")
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss if cancel is pressed
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dictionary may contain multiple representations (edited versions) of an image, select the original
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set displayed image
        mealImageView.image = selectedImage
        
        //Dismiss picker
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mealNameTextField.delegate = self;
        
        // Set up views if editing an existing Meal
        if let meal = meal {
            navigationItem.title = meal.name
            mealNameTextField.text = meal.name
            mealImageView.image = meal.image
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid meal name
        updateSaveButtonState()
        
        // Give image a border
        mealImageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        mealImageView.layer.borderWidth = 2
    }
    
    //MARK: Private Methods
    func updateSaveButtonState() {
        // Disable the save button if the text field is empty
        saveButton.isEnabled = !((mealNameTextField.text ?? "") == "")
    }

}

