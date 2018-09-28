//
//  WordCounter.swift
//  Word Counter
//
//  Created by Sagar on 27/09/18.
//  Copyright © 2018 Sagar. All rights reserved.
//

import UIKit

enum CountingMethod {
    case usingSet
    case usingTrie
    case usingDictionary
    case usingCoreData //Implementation Pending
}

typealias CountingCompletionHandler = ((Int) -> Void)

class WordCounter: NSObject {
    
    private var streamReader: StreamReader
    private var tokenizer: Tokenizer
    private var countingMethod: CountingMethod
    
    init?(withFilePath filePath: String, delimiterCharSet: CharacterSet, countingMethod: CountingMethod) {
        guard let streamReader = StreamReader(path: filePath) else {
            print("Couldn't open stream at path : \(filePath)")
            return nil
        }
        
        self.streamReader = streamReader
        self.tokenizer = Tokenizer(with: delimiterCharSet)
        self.countingMethod = countingMethod
    }
    
    func countWords(withCompletionHandler completion:@escaping CountingCompletionHandler) {
        switch self.countingMethod {
        case .usingSet:
            self.countUniqueWordsUsingSet(withCompletionHandler: completion)
        case .usingTrie:
            self.countUniqueWordsUsingTrie(withCompletionHandler: completion)
        case .usingDictionary:
            self.countUniqueWordsUsingDictionary(withCompletionHandler: completion)
        case .usingCoreData:
            print("Implementation pending")
        }
    }
    
    private func countUniqueWordsUsingSet(withCompletionHandler completion:@escaping CountingCompletionHandler) {
        OperationQueue().addOperation {
            var wordsSet = Set<String>()
            print("Started reading USING SET, time : \(Date())")
            while let line = self.streamReader.nextLine() {
                let words = self.tokenizer.tokensFrom(line)
                words.forEach { (word) in
                    wordsSet.insert(word.lowercased())
                }
            }
            
            print("Done reading USING SET, time : \(Date())")
            OperationQueue.main.addOperation({
                let uniqueWordCount = wordsSet.count
                completion(uniqueWordCount)
            })
        }
    }
    
    private func countUniqueWordsUsingTrie(withCompletionHandler completion:@escaping CountingCompletionHandler) {
        OperationQueue().addOperation {
            let trie = Trie()
            print("Started reading USING TRIE, time : \(Date())")
            while let line = self.streamReader.nextLine() {
                let words = self.tokenizer.tokensFrom(line)
                words.forEach { (word) in
                    trie.insert(word: word)
                }
            }
            print("Done reading USING TRIE, time : \(Date())")
            OperationQueue.main.addOperation({
                completion(trie.count)
            })
        }
    }
    
    private func countUniqueWordsUsingDictionary(withCompletionHandler completion:@escaping CountingCompletionHandler) {
        OperationQueue().addOperation {
            var dictionary = [String:Int]()
            print("Started reading USING DICT, time : \(Date())")
            while let line = self.streamReader.nextLine() {
                let words = self.tokenizer.tokensFrom(line)
                words.forEach { (word) in
                    let lowerCasedWord = word.lowercased()
                    if let existingCount = dictionary[lowerCasedWord] {
                        dictionary[lowerCasedWord] = existingCount + 1
                    } else {
                        dictionary[lowerCasedWord] = 1
                    }
                }
            }
            print("Done reading USING DICT, time : \(Date())")
            OperationQueue.main.addOperation({
                completion(dictionary.keys.count)
            })
        }
    }
}
