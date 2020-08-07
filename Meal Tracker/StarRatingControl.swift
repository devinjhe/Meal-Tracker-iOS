//
//  StarRatingControl.swift
//  Meal Tracker
//
//  Created by Devin He on 11/04/2020.
//  Copyright © 2020 Devin He. All rights reserved.
//

import UIKit

@IBDesignable class StarRatingControl: UIStackView {
    //MARK: Properties
    private var starRatingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupStarButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupStarButtons()
        }
    }
    
    //MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStarButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStarButtons()
    }
    
    //MARK: Button Actions
    @objc func buttonTapped(button: UIButton) {
        guard let index = starRatingButtons.firstIndex(of: button) else {
            fatalError("The button \(button) is not in the button array \(starRatingButtons)")
        }
        
        // Convert from index to rating
        let selectedRating = index + 1
        
        // Reset rating if current rating is selected
        if (selectedRating == rating) {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    private func setupStarButtons() {
        // Clear existing buttons if any
        for button in starRatingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        starRatingButtons.removeAll()
        
        // Load star assets
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // Adding in the buttons
        for index in 0..<starCount {
            // Create button
            let button = UIButton()
            
            // Set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Add accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup button action
            button.addTarget(self, action: #selector(StarRatingControl.buttonTapped(button:)), for: .touchUpInside)
            
            // Add button to stack view
            addArrangedSubview(button)
            
            // Add button to array
            starRatingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in starRatingButtons.enumerated() {
            // If the button index is less than the rating then it should be selected
            button.isSelected = index < rating
            
            // Set the accessibility hint string
            let hintString: String?
            if (index == rating - 1) {
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }
            
            // Set the accessibility value string
            let valueString: String?
            switch(rating) {
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "Rating of 1 star set"
            default:
                valueString = "Rating of \(rating) stars set"
            }
                
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
