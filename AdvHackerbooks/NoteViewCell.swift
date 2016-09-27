//
//  NoteViewCell.swift
//  AdvHackerbooks
//
//  Created by jro on 27/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell {

    @IBOutlet weak var latitudeView: UILabel!
    @IBOutlet weak var longitudeView: UILabel!
    @IBOutlet weak var modificationDateView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
