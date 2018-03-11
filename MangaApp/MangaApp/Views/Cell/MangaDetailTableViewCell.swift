//
//  MangaDetailTableViewCell.swift
//  MangaApp
//
//  Created by lhvan on 3/4/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit

class MangaDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chapterTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpCell(shortChapterDetail: ShortChapterDetail){
        if shortChapterDetail.chapterName.count <= 3 {
            chapterTitleLabel.text = "Chapter \(shortChapterDetail.chapterNumber)"
        }else{
            chapterTitleLabel.text = "Chapter \(shortChapterDetail.chapterNumber): \(shortChapterDetail.chapterName)"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
