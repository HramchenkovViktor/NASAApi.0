//
//  ViewController.swift
//  NASAApi
//
//  Created by Виктор on 23.09.2026.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupConstraints()
        
        Task {
            await loadData()
        }
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
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
            await MainActor.run {  titleLabel.text = nasaImage.title }
            
        } catch {
            print(error)
        }
    }
    
}
