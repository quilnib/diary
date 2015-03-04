//
//  DiaryEntry.swift
//  Diary
//
//  Created by Tim Walsh on 3/3/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import Foundation
import CoreData

@objc(DiaryEntry) //have to add this so xcode can reference this class while saving, I guess.  It solves the "unable to load class" error

class DiaryEntry: NSManagedObject {

    @NSManaged var date: NSTimeInterval
    @NSManaged var body: String
    @NSManaged var imageData: NSData
    @NSManaged var mood: Int16
    @NSManaged var location: String
    
    
    enum diaryEntryMood: int_fast16_t {
        case DiaryEntryMoodGood = 0
        case DiaryEntryMoodAverage = 1
        case DiaryEntryMoodBad = 2
    }

}
