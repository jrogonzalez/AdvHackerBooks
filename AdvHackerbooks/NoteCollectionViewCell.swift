//
//  NoteCollectionViewCell.swift
//  AdvHackerbooks
//
//  Created by jro on 05/10/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var positionView: UIImageView!
    
    @IBOutlet weak var modificationDateView: UILabel!

    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
