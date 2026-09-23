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
    private let dateLabel = UILabel()
    private let explanationLabel = UILabel()
    private let urlImageView = UIImageView()
    
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
        view.addSubview(dateLabel)
        view.addSubview(explanationLabel)
        view.addSubview(urlImageView)
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        dateLabel.textAlignment = .center
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.numberOfLines = 0
        
        explanationLabel.font = .systemFont(ofSize: 16, weight: .regular)
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        
        urlImageView.contentMode = .scaleAspectFit
        urlImageView.clipsToBounds = true
        urlImageView.layer.cornerRadius = 10
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        urlImageView.snp.makeConstraints {
            $0.top.equalTo(explanationLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
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
            await MainActor.run {
                titleLabel.text = nasaImage.title
                dateLabel.text = nasaImage.date
                explanationLabel.text = nasaImage.explanation
                }
            guard let imageURL = URL(string: nasaImage.url) else {
                return
            }
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            
            guard let image = UIImage(data: imageData) else {
                return
            }
            await MainActor.run {
                urlImageView.image = image
            }
        } catch {
            print(error)
        }
    }
    
}
