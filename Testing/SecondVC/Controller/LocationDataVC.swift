//
//  LocationDataVC.swift
//  Testing
//
//  Created by Arun Cheela on 22/11/21.
//

import UIKit

class LocationDataVC: UIViewController {
    private var apiService : APIService!
    private let sourcesURL = "http://api.openweathermap.org/data/2.5/weather?lat="
    private let APIKey = "fae7190d7e6433ec3a45285ffcf55c86"
    let ImageURL = "http://openweathermap.org/img/wn/"
//    private let sourcesURL = "http://api.openweathermap.org/data/2.5/find?q="
    
    @IBOutlet weak var location_TableView: UITableView!
    var lat = ""
    var lng = ""
    var cityName = ""
    var copyWeatherData: NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        UserDefaults.standard.removeObject(forKey: "Data")
        registerCells()
        self.callWeatherAPi()
    }
    
    func registerCells() {
        self.location_TableView.delegate = self
        self.location_TableView.dataSource = self
        self.location_TableView.separatorStyle = .none
        self.location_TableView.allowsSelection = false
        self.location_TableView.register(UINib(nibName: "HeaderCell", bundle: .main), forCellReuseIdentifier: "HeaderCell")

        self.location_TableView.register(UINib(nibName: "LocationTableViewCell", bundle: .main), forCellReuseIdentifier: "LocationTableViewCell")

//        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - APi Methos
    func callWeatherAPi() {

        let baseUrlString = String(format: "%@%@%@%@%@%@", sourcesURL,lat,"&lon=",lng,"&appid=",APIKey)
        let url = URL(string: baseUrlString)
        print(url as Any)
        
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                let copyData = json as! NSDictionary
                print(copyData)
                self.copyWeatherData = json as! NSDictionary
                UserDefaults.standard.set(self.copyWeatherData, forKey: "Data")
                DispatchQueue.main.async {
                    self.location_TableView.reloadData()
                }

            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }


}
extension LocationDataVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            if self.copyWeatherData.count > 0 {
                cell.name_lbl.text =  String(format: "%@ %@", self.copyWeatherData.value(forKey: "name") as! CVarArg,cityName )
                let weatherArray = self.copyWeatherData.value(forKey: "weather") as! NSArray
                let weatherDict = weatherArray[0] as? NSDictionary
                cell.description_Lbl.text = weatherDict?.value(forKey: "main") as? String
                let imageIDString = weatherDict?.value(forKey: "icon") as? String
                let imageUrlString = String(format: "%@%@%@", ImageURL,imageIDString!,"@2x.png")
                cell.weatherImage.downloaded(from: imageUrlString)
            }
           
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
            if self.copyWeatherData.count > 0 {
                cell.setShapes()
            }
           
            return cell

        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 181
        } else {
            return 300
        }
    }

}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
