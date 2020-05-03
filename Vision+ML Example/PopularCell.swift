import UIKit

class PopularCell: UITableViewCell {

    
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var mealPicture: UIImageView!
    @IBOutlet weak var rating: UILabel!
    
     
    
    
    override func awakeFromNib() {
        mealPicture.layer.borderColor = UIColor.cyan.cgColor
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
