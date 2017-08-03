import UIKit

class TableViewCellTextView: UITableViewCell 
{

    @IBOutlet weak var lbTips: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) 
    {
        super.setSelected(selected, animated: animated)
    }

}
