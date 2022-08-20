//
//  DayForecastTableViewCell.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class DayForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherIconView: UIImageView!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setForecast(_ data: ForecastData) {
        if let validDate = data.valid_date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: validDate)
            weekDayLabel.text = date?.weekdayText
        }
        
        maxTempLabel.text = "\(data.max_temp)°"
        minTempLabel.text = "\(data.min_temp)°"
        weatherIconView.load(src: data.weather.iconURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
