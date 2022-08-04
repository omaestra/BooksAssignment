//
//  BookTableViewCell.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit
import Kingfisher

class BookTableViewCell: UITableViewCell, ReusableView & NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureView(title: String?) {
        self.titleLabel.text = title
    }
}
