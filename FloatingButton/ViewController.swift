//
//  ViewController.swift
//  FloatingButton
//
//  Created by Jorge Abalo Dieste on 13/2/24.
//
import UIKit

class ViewController: UIViewController {

    // Botón principal para expandir y contraer el stackView
    let mainButton: UIButton = {
        let button = UIButton()
        button.setTitle("△", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    // Botón de búsqueda, se mostrará al expandir el stackView
    let searchButton: UIButton = {
        let button = UIButton()
        let searchIcon = "🔍"
        button.setTitle(searchIcon + " Buscar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    // Vista separadora entre los botones
    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return separatorView
    }()
    // Los botones y la separación
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        stackView.semanticContentAttribute = .forceRightToLeft
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = true
        return stackView
    }()

    private var mainButtonHeightConstraint: NSLayoutConstraint?
    private var separatorWidthConstraint: NSLayoutConstraint?

    // Estado para rastrear si el stackView está expandido o contraído
    var isExpanded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.addArrangedSubview(mainButton)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(searchButton)

        view.addSubview(stackView)

        // Configurar restricciones y animar el stackView
        setupConstraints()
        animateStackView()
    }

    // Configurar las restricciones iniciales del stackView
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        mainButtonHeightConstraint = mainButton.heightAnchor.constraint(equalToConstant: isExpanded ? 40 : 30)
        separatorWidthConstraint = separatorView.widthAnchor.constraint(equalToConstant: isExpanded ? 1 : 0)

        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            // Ajustar la restricción del stackView para comenzar desde la esquina inferior derecha
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainButtonHeightConstraint!,
            separatorWidthConstraint!
        ])
        
       
    }

    // Animar el stackView para mostrar el botón de búsqueda al inicio de la aplicación
    private func animateStackView() {
        mainButton.setTitle("△ ", for: .normal)
        mainButtonHeightConstraint?.constant = 40
        separatorWidthConstraint?.constant = 1

        // Configurar la posición inicial del stackView fuera de la pantalla
        stackView.transform = CGAffineTransform(translationX: view.bounds.width, y: view.bounds.height)

        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            // Restaurar la posición original del stackView durante la animación
            self.stackView.transform = .identity
            self.view.layoutIfNeeded()
            self.stackView.layer.cornerRadius = 20
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.searchButton.isHidden = !self.searchButton.isHidden
            }, completion: { _ in
                self.isExpanded = true
            })
        })
    }

    // Método llamado cuando se toca el botón principal para expandir o contraer el stackView
    @objc private func mainButtonTapped() {
        if isExpanded {
            mainButton.setTitle("△ ", for: .normal)
            mainButtonHeightConstraint?.constant = 30
            separatorWidthConstraint?.constant = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
                self.stackView.layer.cornerRadius = 15
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.searchButton.isHidden = !self.searchButton.isHidden
                }, completion: { _ in
                    self.isExpanded = false
                })
            })
        } else {
            mainButton.setTitle("△ ", for: .normal)
            mainButtonHeightConstraint?.constant = 40
            separatorWidthConstraint?.constant = 1
            UIView.animate(withDuration: 0.4, animations: {
                self.view.layoutIfNeeded()
                self.stackView.layer.cornerRadius = 20
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
