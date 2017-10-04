//
//  InterfaceController.swift
//  Time Tracker WatchKit Extension
//
//  Created by Hani Tawil on 29/08/2017.
//  Copyright © 2017 Hani Tawil. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {

    @IBOutlet var displayBPM: WKInterfaceImage!
    var currentBPM = 140;
    var timer = Timer.init();
    var checker : HKWorkoutSession?;
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let healthStore = HKHealthStore();
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .indoor
        
        do {
            checker = try HKWorkoutSession(configuration: configuration)
            
            checker?.delegate = self as? HKWorkoutSessionDelegate
            healthStore.start(checker!)
        }
        catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
        
        displayBPM.setImageNamed(String(currentBPM) + "BPM")
        
        startMetronome();
    }
    
    func startMetronome() {
        timer.invalidate();
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(60).divided(by: TimeInterval(currentBPM)), repeats: true) { (timer) in
            WKInterfaceDevice.current().play(.start);
        }
    }
        
    @IBAction func downTapped() {
        currentBPM -= 1;
        displayBPM.setImageNamed(String(currentBPM) + "BPM")
        startMetronome();
    }
    
    @IBAction func upTapped() {
        currentBPM += 1;
        displayBPM.setImageNamed(String(currentBPM) + "BPM")
        startMetronome();
        print(checker?.state.rawValue ?? "Dun goofed");
    }

}
