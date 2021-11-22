//
//  LocationTableViewCell.swift
//  Testing
//
//  Created by Arun Cheela on 23/11/21.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    var copyWeatherData: NSDictionary = NSDictionary()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCollectionLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCollectionLayout() {
        self.locationCollectionView.dataSource = self
        self.locationCollectionView.delegate = self
        self.locationCollectionView.register(UINib(nibName: "DataCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "DataCollectionViewCell")
        let layout = self.locationCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: (self.locationCollectionView.frame.size.width)/1.8, height: 120)
        layout.scrollDirection = .vertical
    }
    func setShapes() {
        
        self.copyWeatherData = UserDefaults.standard.object(forKey: "Data") as! NSDictionary
        self.locationCollectionView.reloadData()
    }
}
extension LocationTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as? DataCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.description_lbl.textAlignment = .center
            cell.title_lbl.textAlignment = .center
            
            if self.copyWeatherData.count > 0 {
                let getWindDict = self.copyWeatherData.value(forKey: "wind") as! NSDictionary
                let windSpeed = getWindDict.value(forKey: "speed") as! Double
                cell.description_lbl.text = "\(windSpeed) m/s"
                cell.title_lbl.text = "Wind Speed"
            } else {
                cell.description_lbl.text = ""
                cell.title_lbl.text = ""
            }
           
            return cell

        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as? DataCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.description_lbl.textAlignment = .center
            cell.title_lbl.textAlignment = .center
            if self.copyWeatherData.count > 0 {
                let getmainDict = self.copyWeatherData.value(forKey: "main") as! NSDictionary
                let humidity = getmainDict.value(forKey: "humidity") as! Int
                cell.description_lbl.text = "\(humidity)%"
                cell.title_lbl.text = "Humidity"
            } else {
                cell.description_lbl.text = ""
                cell.title_lbl.text = ""
            }
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as? DataCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.description_lbl.textAlignment = .center
            cell.title_lbl.textAlignment = .center
            if self.copyWeatherData.count > 0 {
                let getvisibility = self.copyWeatherData.value(forKey: "visibility") as! Int
                cell.description_lbl.text = String(getvisibility)
                cell.title_lbl.text = "visibility"
            } else {
                cell.description_lbl.text = ""
                cell.title_lbl.text = ""
            }
            
            return cell
            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as? DataCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.description_lbl.textAlignment = .center
            cell.title_lbl.textAlignment = .center
            if self.copyWeatherData.count > 0 {
                let getmainDict = self.copyWeatherData.value(forKey: "main") as! NSDictionary
                let temp = getmainDict.value(forKey: "temp") as! Double
                cell.description_lbl.text = String(temp)
                cell.title_lbl.text = "Temperature"
            } else {
                cell.description_lbl.text = ""
                cell.title_lbl.text = ""
            }
           
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            let cellWidth: CGFloat = 276.0
            let numberOfCells = floor(self.main_View.frame.size.width / cellWidth)
            let edgeInsets = (self.main_View.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            return UIEdgeInsets(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
/*
self.weatherLabel.text = weather.weatherDescription
    self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
    self.cloudCoverLabel.text = "\(weather.cloudCover)%"
    
*/
