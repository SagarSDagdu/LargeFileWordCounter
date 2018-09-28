//
//  WordsViewController.swift
//  Word Counter
//
//  Created by Sagar on 26/09/18.
//  Copyright © 2018 Sagar. All rights reserved.
//

import UIKit
import CoreData

class WordsViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet weak var numberOfWordsLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countingStartTimeLabel: UILabel!
    @IBOutlet weak var countingEndTimeLabel: UILabel!
    
    var countingMethod: CountingMethod = .usingSet //Change this for testing other approaches
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.startCountingWords()
    }
    
    //MARK:- Helpers
    
    private func setupUI() {
        self.countLabel.text = "0"
        self.activityIndicator.isHidden = true
    }
    
    private func showWaitView() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    private func hideWaitView() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    private func setStartTime() {
        self.countingStartTimeLabel.text = "Start time : \(DateUtil.logsDateString(from: Date()))"
    }
    
    private func setEndTime() {
        self.countingEndTimeLabel.text = "End time : \(DateUtil.logsDateString(from: Date()))"
    }
    
    //MARK:- Logic
    
    private func startCountingWords() {
        self.showWaitView()
        guard let filePath =  Bundle.main.path(forResource: Constants.fileToRead, ofType: "txt") else {
            print("Couldn't FIND file at specified path")
            self.hideWaitView()
            return
        }
        
        let delimiterCharSet = CharacterSet(charactersIn: Constants.delimiterString)
        if let wordCounterUsingSet = WordCounter(withFilePath: filePath, delimiterCharSet: delimiterCharSet, countingMethod: self.countingMethod) {
            self.setStartTime()
            wordCounterUsingSet.countWords() { (count) in
                self.setEndTime()
                self.hideWaitView()
                self.countLabel.text = "\(count)"
                print("Count of unique words is : \(count)")
            }
        }
    }
}

