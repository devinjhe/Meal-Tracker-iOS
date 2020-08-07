//
//  MealTableViewController.swift
//  Meal Tracker
//
//  Created by Devin He on 12/04/2020.
//  Copyright © 2020 Devin He. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load some sample data
            loadSampleMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cells in the table view should be reused and dequeued using a cell identifier
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }
        
        // Fetch appropriate meal for the data source layout
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.mealImageView.image = meal.image
        cell.ratingControl.rating = meal.rating
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddMeal":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetails":
            guard let mealDetailsViewController = segue.destination as? MealEditViewController else {
                fatalError("Unexpected destination from MealTableViewController: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender from MealTableViewController: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailsViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealEditViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // This means the user is updating an existing meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Adding a new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals
            saveMeals()
        }
    }
    
    //MARK: Private Methods
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "Fried Rice")
        let photo2 = UIImage(named: "Sushi")
        
        guard let meal1 = Meal(name: "Fri Rie", image: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Suuushh", image: photo2, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        meals += [meal1, meal2]
    }
    
    private func saveMeals() {
        do {
            let saveData = try NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            try saveData.write(to: Meal.ArchiveURL)
            os_log("Meals saved successfully", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meals", log: OSLog.default, type: .debug)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        do {
            let data = try Data(contentsOf: Meal.ArchiveURL)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Meal]
        } catch {
            os_log("Failed to load meals", log: OSLog.default, type: .debug)
        }
        return nil
    }
}
