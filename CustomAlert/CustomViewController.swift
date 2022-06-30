//
//  CustomVievController.swift
//  CustomAlert
//
//  Created by Ibrohimjon Mamajonov on 30/06/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CustomViewController: UIViewController {
    
    let hStackView = UIStackView()
    let vStackView = UIStackView()
    let timerLabel = UILabel()
    var totalTime = 600
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        alertView()
        startTimer()
        print("CustomViewController is called")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show() {
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController!.present(self, animated: true, completion: nil)
        }
    }
    
    func alertView(){
        hStackView.layer.cornerRadius = 15
        hStackView.backgroundColor = .white
        view.addSubview(hStackView)
        hStackView.axis = .vertical
        hStackView.distribution = .fillEqually
        hStackView.spacing = 5
        titleLabel()
        numberLabel()
        buttonsStack()
        
        setStackViewConstraints()
    }
    func setStackViewConstraints(){
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        hStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        hStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hStackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    func titleLabel(){
        let label = UILabel()
        label.text = "Оплатить предзаказ"
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.textAlignment = .center
        hStackView.addArrangedSubview(label)
        
        
    }
    
    //Timer
    
    func numberLabel(){
        
        timerLabel.text = "10:00"
        timerLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        timerLabel.alpha = 0.6
        timerLabel.textAlignment = .center
        hStackView.addArrangedSubview(timerLabel)
    }
    
    
    func buttonsStack(){
        
        vStackView.axis = .horizontal
        vStackView.spacing = 10
        vStackView.distribution = .fillProportionally
        vStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        vStackView.isLayoutMarginsRelativeArrangement = true
        buttonCancel()
        buttonPay()
        hStackView.addArrangedSubview(vStackView)
    }
    
    func buttonCancel(){
        let button = UIButton()
        button.backgroundColor = UIColor(named: "cancelBackground")
        button.layer.cornerRadius = 25
        button.setTitle("Отмена", for: .normal)
        button.addTarget(self, action: #selector(self.buttonActionCancel), for: .touchUpInside)
        vStackView.addArrangedSubview(button)
        
    }
    func buttonPay(){
        let button = UIButton()
        button.backgroundColor = UIColor(named: "payBackground")
        button.layer.cornerRadius = 25
        button.setTitle("Оплатить", for: .normal)
        button.addTarget(self, action: #selector(self.buttonActionPay), for: .touchUpInside)
        vStackView.addArrangedSubview(button)
    }
    func startTimer() {

        //turn the rx timer

        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                .take(self.totalTime+1)
                .subscribe(onNext: { timePassed in
                    let count = self.totalTime - timePassed
                    print(count)
                    self.updateTime()

                }, onCompleted: {
                    print("count down complete")
                })
       }
    @objc func updateTime() {
            timerLabel.text = "\(timeFormatted(totalTime))"
        

            if totalTime != 0 {
                totalTime -= 1
            } else {
                self.timerLabel.text = "Time limit has finished!!.."
            }
        }

        func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }

    @objc func buttonActionCancel(sender: UIButton!) {
       print("Button Cancel tapped")
        dismiss(animated: true)
        
    }
    
    @objc func buttonActionPay(sender: UIButton!) {
       print("Button Pay tapped")
        
    }
    var sourceObservable: Disposable?
   
}
