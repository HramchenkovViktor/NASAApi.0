//
//  ViewController.swift
//  NASAApi
//
//  Created by Виктор on 23.09.2026.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
              await loadData()
          }
    }
    private func loadData() async {
        guard let url = URL(
            string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY"
        ) else {
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                return
            }
            let nasaImage = try JSONDecoder().decode(NASAImage.self, from: data)
            print(nasaImage.title)

        } catch {
            print(error)
        }
    }
    
}
