//
//  BookViewCell.swift
//  AdvHackerbooks
//
//  Created by jro on 09/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

class BookViewCell: UITableViewCell {

    @IBOutlet weak var bookPhotoView: UIImageView!    
    @IBOutlet weak var tagsView: UILabel!
    @IBOutlet weak var favPhotoView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
