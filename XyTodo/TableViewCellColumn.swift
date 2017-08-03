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
