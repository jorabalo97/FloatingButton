//
//  ViewController.swift
//  FloatingButton
//
//  Created by Jorge Abalo Dieste on 13/2/24.
//
import UIKit

class ViewController: UIViewController {

    let mainButton: UIButton = {
        let button = UIButton()
        button.setTitle("△ ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        return button
    }()

    let searchButton: UIButton = {
        let button = UIButton()
        let searchIcon = "🔍" // Emoji de lupa
        button.setTitle(searchIcon + " Buscar...", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        return button
    }()

    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return separatorView
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        stackView.semanticContentAttribute = .forceRightToLeft
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()

    private var mainButtonHeightConstraint: NSLayoutConstraint?
    private var separatorWidthConstraint: NSLayoutConstraint?

    var isExpanded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.addArrangedSubview(mainButton)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(searchButton)

        view.addSubview(stackView)

        setupConstraints()
    }

    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        mainButtonHeightConstraint = mainButton.heightAnchor.constraint(equalToConstant: isExpanded ? 40 : 30)
        separatorWidthConstraint = separatorView.widthAnchor.constraint(equalToConstant: isExpanded ? 1 : 0)

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainButtonHeightConstraint!,
            separatorWidthConstraint!
        ])
    }

    @objc func mainButtonTapped() {
        if isExpanded {
            mainButton.setTitle("△ ", for: .normal)
            mainButtonHeightConstraint?.constant = 30
            separatorWidthConstraint?.constant = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.searchButton.isHidden = !self.searchButton.isHidden
                }, completion: { _ in
                    self.isExpanded = false
                })
            })
        } else {
            mainButton.setTitle("◁ ", for: .normal)
            mainButtonHeightConstraint?.constant = 40
            separatorWidthConstraint?.constant = 1
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.searchButton.isHidden = !self.searchButton.isHidden
                }, completion: { _ in
                    self.isExpanded = true
                })
            })
        }
    }
}
