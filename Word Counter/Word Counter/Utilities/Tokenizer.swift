//
//  Tokenizer.swift
//  Word Counter
//
//  Created by Sagar on 26/09/18.
//  Copyright © 2018 Sagar. All rights reserved.
//

import UIKit

class Tokenizer: NSObject {
    
    private var delimiterCharSet: CharacterSet
    
    init(with delimiterCharSet:CharacterSet) {
        self.delimiterCharSet = delimiterCharSet
    } 
    
    func tokensFrom(_ string: String) -> [String] {
         return string.components(separatedBy: self.delimiterCharSet).filter({$0 != ""})
    }
    
}
