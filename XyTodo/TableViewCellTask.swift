import UIKit

class TableViewCellTask: UITableViewCell
{
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var cbTag: VKCheckbox!
    @IBOutlet weak var vCard: CardView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        cbTag.line = .Normal
        cbTag.bgColorSelected  = UIColor.white
        cbTag.borderColor      = UIColor.white
        cbTag.borderWidth      = 3
        cbTag.cornerRadius     = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
