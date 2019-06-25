//
//  AppReviewManager.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import UIKit
import StoreKit

class AppReviewManager {
    
    private let launchCountUserDefaultsKey = "numberOfLaunches"
    private let minimumLaunchCount = 10
    
    func checkToShowReviewView(){
        if isReviewViewToBeDisplayed() {
            SKStoreReviewController.requestReview()
        }
    }
    
    // MARK: Private Methods
    private func isReviewViewToBeDisplayed() -> Bool {
        let launchCount = UserDefaults.standard.integer(forKey: launchCountUserDefaultsKey)
        
        if launchCount >= minimumLaunchCount {
            UserDefaults.standard.set(0, forKey: launchCountUserDefaultsKey)
            return true
        } else {
            UserDefaults.standard.set((launchCount + 1), forKey: launchCountUserDefaultsKey)
            return false
        }
    }
}
