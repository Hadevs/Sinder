import UIKit
import MapKit

// Convert CLLocationCoordinate2D to CLLocation
public extension CLLocationCoordinate2D {
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}

// Short function to hide or show navigation bar
public extension UINavigationController {
    func hide() {
        navigationBar.isHidden = true
    }
    
    func show() {
        navigationBar.isHidden = false
    }
}

// convert CLPlacemark to normal default address of type string
public extension CLPlacemark {
    func toNormalAddress() -> String {
        var addressArray: [String] = []
        
        if let country = subAdministrativeArea {
            addressArray.append(country)
        }
        
        if let city = locality {
            addressArray.append(city)
        }
        
        if let street = thoroughfare {
            addressArray.append(street)
        }
        
        if let number = subThoroughfare {
            addressArray.append(number)
        }
        
        return addressArray.joined(separator: ", ")
    }
    
}

// enum for transfering
public enum TransferMethod {
    case push
    case pop
    case present
    case show
}

// extension for getting IndexPath from UIView in UITableViewCell
public extension UITableView {
    func indexPath(for view: AnyObject) -> IndexPath? {
        let originInTableView = self.convert(CGPoint.zero, from: (view as! UIView))
        return self.indexPathForRow(at: originInTableView)
    }
}

public extension Date {
    
    // converting date to String with format.
    func convertToString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let timeStamp = dateFormatter.string(from: self)
        return timeStamp
    }
    
    // Date of start current day.
    var startOfDay: NSDate {
        return NSCalendar.current.startOfDay(for: self) as NSDate
    }
    
    // Date of end current day.
    var endOfDay: NSDate? {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.current.date(byAdding: components as DateComponents, to: startOfDay as Date)! as NSDate
    }
}

public extension String {
    // Not-mutable function for removing text from string.
    func remove(text: String) -> String {
        return replacingOccurrences(of: text, with: "")
    }
    
    // checking email string is valid
    func isEmailValid() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: self) {
            return true
        }
        return false
    }
    
    // Transliterating cyrillic text to latin
    func toLatinTransliteration() -> String {
        var returned = ""
        let rus = [" ","а","б","в","г","д","е","ё", "ж","з","и","й","к","л","м","н","о","п","р","с","т","у","ф","х", "ц","ч", "ш","щ","ъ","ы","ь","э", "ю","я","А","Б","В","Г","Д","Е","Ё", "Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х", "Ц", "Ч","Ш", "Щ","Ъ","Ы","Б","Э","Ю","Я","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y", "Z"]
        let eng = [" ","a","b","v","g","d","e","e","zh","z","i","y","k","l","m","n","o","p","r","s","t","u","f","h","ts","ch","sh","sch", "","i", "","e","ju","ja","A","B","V","G","D","E","E","Zh","Z","I","Y","K","L","M","N","O","P","R","S","T","U","F","H","Ts","Ch","Sh","Sch", "","I", "","E","Ju","Ja","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        
        for character in characters {
            for r in rus where String(describing: character) == r {
                let index = rus.index(of: r)
                returned += eng[index!]
            }
        }
        
        return returned
    }
}


public extension UIViewController {
    // previous vc of Navigation Controller hierarchy
    func prevVC() -> UIViewController? {
        if navigationController!.childViewControllers.contains(index: navigationController!.childViewControllers.count - 2) {
            return navigationController!.childViewControllers[navigationController!.childViewControllers.count - 2]
        } else {
            return nil
        }
    }
    
    // Dismiss if VC presented, poping if VC pushed.
    func smartBack() {
        if isModal() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // showing alert with title, message and action, when pressing "OK" button
    func showAlertWithOneAction(title: String, message: String, handle: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            handle()
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // Checking if UIViewController presented or pushed. If true - presented.
    func isModal() -> Bool {
        
        if let navigationController = self.navigationController{
            if navigationController.viewControllers.first != self{
                return false
            }
        }
        
        if self.presentingViewController != nil {
            return true
        }
        
        if self.presentingViewController?.presentedViewController == self {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    
    //set image to View and add new elemnt UIImageView
    func setImage(image: UIImage, toView: UIView) {
        let replaceView = UIImageView(image: image)
        replaceView.translatesAutoresizingMaskIntoConstraints = false
        replaceView.contentMode = .scaleToFill
        self.view.addSubview(replaceView)
        self.view.sendSubview(toBack: replaceView)
        
        let top = NSLayoutConstraint(item: replaceView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: replaceView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: replaceView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: replaceView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([top, leading, trailing, bottom])
    }
    
    // open new VC in storyboard with indentifier and method
    func transfer(with identifier: String, and method: TransferMethod) {
        if method == .pop {
            _ = navigationController?.popViewController(animated: true)
        } else if method == .present {
            self.present(self.storyboard!.instantiateViewController(withIdentifier: identifier), animated: true, completion: nil)
        } else if method == .push {
            self.navigationController?.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: identifier), animated: true)
        } else if method == .show {
            self.show(self.storyboard!.instantiateViewController(withIdentifier: identifier), sender: self)
        }
    }
    
    // presenting new VC with embedded navigaiton controller
    func presentWithNC(withIdentifier identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    //easy way to show alert with title and message
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // easy way to shwo alert with title, message, optional cancel button, and unlimited count of buttons
    func showAlertWithActions(title: String, message: String, withCancelButton: Bool, buttons: [(title: String, action: () -> Void)]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for button in buttons {
            let okAction = UIAlertAction(title: button.title, style: UIAlertActionStyle.default) {
                UIAlertAction in
                button.action()
            }
            alertController.addAction(okAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .default, handler: nil)
        if withCancelButton {
            alertController.addAction(cancelAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

public extension Array {
    // checking if array contains element with index
    func contains(index: Int) -> Bool {
        return index >= 0 && count - 1 >= index
    }
}

class Sinder: NSObject {
    
    // getting data with url
    static func getData(from url: URL, with completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    // generating random ID
    static func ID() -> String {
        let time = String(Int(NSDate().timeIntervalSince1970), radix: 16, uppercase: false)
        let machine = String(arc4random_uniform(900000) + 100000)
        let pid = String(arc4random_uniform(9000) + 1000)
        let counter = String(arc4random_uniform(900000) + 100000)
        return time + machine + pid + counter
    }
    
    //delay in seconds with closure
    func delay(_ delay:Double, with closure:@escaping ()->()) {
        
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }
}

//set image to imageView from string
extension UIImageView {
    convenience init(string: String) {
        self.init(image: UIImage(named: string))
    }
}

extension UIColor {
    //UIColor from HEX
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIImageView {
    //download image frim server to UIImageView
    func download(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
}


