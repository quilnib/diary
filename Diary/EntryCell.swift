//
//  EntryCell.swift
//  Diary
//
//  Created by Tim Walsh on 3/4/15.
//  Copyright (c) 2015 ClassicTim. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var moodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellForEntry(entry: DiaryEntry) {
        self.bodyLabel.text = entry.body
        
        
        //check if there is a location, then act accordingly
        if (entry.location.isEmpty) {
            self.locationLabel.text = "No location"
        } else {
            self.locationLabel.text = entry.location
        }
        
        
        //if there is an associated image, set it.  Otherwise, use default image
        if (entry.imageData.length > 0) {// if length is 0 then there is no image
            self.mainImageView.image = UIImage(data: entry.imageData)
            println("found an image with length \(entry.imageData.length)")
        } else {
            self.mainImageView.image = UIImage(named: "icn_noimage")
        }
        
        
        //set the mood icon
        if (  entry.mood == DiaryEntry.DiaryEntryMood.DiaryEntryMoodGood.rawValue) {
            self.moodImageView.image = UIImage(named: "icn_happy")
        } else if (entry.mood == DiaryEntry.DiaryEntryMood.DiaryEntryMoodAverage.rawValue) {
            self.moodImageView.image = UIImage(named: "icn_average")
        } else if (entry.mood == DiaryEntry.DiaryEntryMood.DiaryEntryMoodBad.rawValue) {
            self.moodImageView.image = UIImage(named: "icn_bad")
        }
        
        //set the date
        var dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d yyyy")
        var date: NSDate = NSDate(timeIntervalSince1970: entry.date)
        
        self.dateLabel.text = dateFormatter.stringFromDate(date)
        
        self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame) / 2 //set the image to be a circle.  Make sure to select the "Clip Subviews" checkbox in storyboard, or you wont see any effect

    }
    
//    class func heightForEntry(entry: DiaryEntry) -> CGFloat {
//        let topMargin = 35.0
//        let bottomMargin = 39.0
//        let minHeight = 85.0
//        
//        let font = UIFont.systemFontOfSize(UIFont.systemFontSize())
//        
//        
//    }

}
