import UIKit

class TableViewCellTaskNote: UITableViewCell
{

    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var vCard: CardView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
