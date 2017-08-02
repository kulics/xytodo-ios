//
//  TableViewCellColumn.swift
//  XyKey
//
//  Created by 吴森 on 15/11/22.
//  Copyright © 2015年 naxy. All rights reserved.
//

import UIKit

class TableViewCellColumn: UITableViewCell 
{

    @IBOutlet weak var lbColumnTitle: UILabel!
    @IBOutlet weak var lbColumnSub: UILabel!
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) 
    {
        super.setSelected(selected, animated: animated)
    }

}
