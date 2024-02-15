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
        button.setTitle("⌃", for: .normal) // Cambiado de "△" a "⌃"
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
        button.contentEdgeInsets = UIEdgeInsets( top: 0, left: 10, bottom: 0, right: 0)
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
        stackView.spacing = 10
        stackView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        stackView.semanticContentAttribute = .forceRightToLeft
        stackView.layer.cornerRadius = 20
        stackView.layer.masksToBounds = true
        
        let spacerView = UIView()
        stackView.addArrangedSubview(spacerView)
        
        
        return stackView
    }()
    
    private var mainButtonHeightConstraint: NSLayoutConstraint?
    private var separatorWidthConstraint: NSLayoutConstraint?
    
    // Estado para rastrear si el stackView está expandido o contraído
    var isExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        animateStackView()
    }
    
    private func setupUI() {
        stackView.addArrangedSubview(mainButton)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(searchButton)
        
        view.addSubview(stackView)
    }
    
    // Configurar las restricciones iniciales del stackView
    private func setupConstraints() {
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
    
    // Animar el stackView para mostrar el botón de búsqueda al inicio de la aplicación
    private func animateStackView() {
        
        // Ajusta la altura del mainButton
        mainButtonHeightConstraint?.constant = 40
        
        // Ajusta el ancho de la vista separadora
        separatorWidthConstraint?.constant = 0
        
        // Aplica una transformación de desplazamiento al stackView para colocarlo fuera de la pantalla
        stackView.transform = CGAffineTransform(translationX: view.bounds.width, y: view.bounds.height)
        
        // Inicia la primera animación
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            
            // Revierte la transformación, devuelve el stackView a su posición original
            self.stackView.transform = .identity
            
            // Actualiza el diseño para aplicar los cambios
            self.view.layoutIfNeeded()
            
            // Redondea las esquinas del stackView
            self.stackView.layer.cornerRadius = 20
        }, completion: { _ in
            
            // Comienza la segunda animación dentro del bloque de finalización de la primera animación
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                
                // Muestra u oculta el botón de búsqueda
                self.searchButton.isHidden.toggle()
                
            }, completion: { _ in
                
                // Establece el estado de expansión a true
                self.isExpanded = true
                
                // Llama a la función para animar la vista separadora
                self.animateSeparator()
            })
        })
    }
    
    private func animateSeparator() {
        separatorWidthConstraint?.constant = 1
        
        // Inicialmente hace invisible la vista separadora en términos de ancho
        separatorView.transform = CGAffineTransform(scaleX: 0, y: 1.5)

        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            
            // Revierte la transformación de escala, volviendo a la escala original
            self.separatorView.transform = CGAffineTransform(scaleX: 1, y: 0.2)
            
            self.view.layoutIfNeeded()
        }, completion:  { _ in
            UIView.animate(withDuration: 0.6,delay: 0, options: .curveEaseInOut, animations: {
                self.separatorView.transform = CGAffineTransform(scaleX: 1, y: 0.6 )
                self.view.layoutIfNeeded()
            }, completion:  { _ in
                UIView.animate(withDuration: 0.4,delay: 0,  options: .curveEaseInOut, animations: {
                    self.separatorView.transform = .identity
                    self.view.layoutIfNeeded()
                })
            })
            
        
        })
    }
    
    @objc private func mainButtonTapped() {
        
        // Calcula la nueva altura del mainButton basándose en el estado de expansión
        let newHeight = isExpanded ? 30 : 40
        
        // Calcula el nuevo ancho de la vista separadora basándose en el estado de expansión
        let newSeparatorWidth = isExpanded ? 0 : 1
        
        mainButtonHeightConstraint?.constant = CGFloat(newHeight)
        
        // Inicia la animación principal
        UIView.animate(withDuration: 0.4, animations: {
            
            // Actualiza el diseño para aplicar cambios en tiempo real
            self.view.layoutIfNeeded()
            self.stackView.layer.cornerRadius = CGFloat(newHeight) / 2
            
        }, completion: { _ in
            
            // Inicia una segunda animación
           
                self.searchButton.isHidden.toggle()
                self.separatorWidthConstraint?.constant = CGFloat(newSeparatorWidth)
            self.animateSeparator()
            
            
                
                // Invierte el estado de expansión del stackView
                self.isExpanded.toggle()
            })
        }
    }

