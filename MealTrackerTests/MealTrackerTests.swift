//
//  MealTrackerTests.swift
//  MealTrackerTests
//
//  Created by Devin He on 11/04/2020.
//  Copyright © 2020 Devin He. All rights reserved.
//

import XCTest
@testable import Meal_Tracker

class MealTrackerTests: XCTestCase {
    //MARK: Meal Class Tests
    
    // Confirm Meal Class initialiser return a Meal object if valid paramters are given
    func testMealClassInitialiserSucceeds() {
        // Zero rating meal
        let zeroRatingMeal = Meal.init(name: "Zero", image: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Max possible rating meal
        let maxRatingMeal = Meal.init(name: "Max", image: nil, rating: 5)
        XCTAssertNotNil(maxRatingMeal)
    }
    
    // Confirm Meal Class initialiser returns nil when invalid parameters are given
    func testMealClassInitialiserFails() {
        // Empty name meal
        let noNameMeal = Meal.init(name: "", image: nil, rating: 3)
        XCTAssertNil(noNameMeal)
        
        // Negative rating meal
        let negativeRatingMeal = Meal.init(name: "Negative", image: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)

        // Rating exceeds maximum
        let aboveMaxMeal = Meal.init(name: "AboveMax", image: nil, rating: 6)
        XCTAssertNil(aboveMaxMeal)
    }
}
