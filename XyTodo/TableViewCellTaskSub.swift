import UIKit

class TableViewCellTaskSub: UITableViewCell
{

    @IBOutlet weak var cbxStatus: VKCheckbox!
    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        cbxStatus.line = .Normal
        cbxStatus.bgColorSelected  = PURE_GREEN_500
        cbxStatus.borderColor      = PURE_GREEN_500
        cbxStatus.color            = UIColor.white
        cbxStatus.borderWidth      = 3
        cbxStatus.cornerRadius     = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
