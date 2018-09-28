//
//  Word+CoreDataProperties.swift
//  Word Counter
//
//  Created by Sagar on 26/09/18.
//  Copyright © 2018 Sagar. All rights reserved.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func wordFetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var string: String?

}
