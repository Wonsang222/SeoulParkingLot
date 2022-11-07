//
//  SearchController.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit
import NMapsMap

protocol SearchControllerDelegate: AnyObject{
    func markOnTheMap(location:NMGLatLng, avenue:String)
}

class SearchController:UIViewController{
    
    //MARK: - Properties
    
    var viewModel: SearchViewModel?
    
    private var keyboard = true
    
    var delegate:SearchControllerDelegate?
    
    private let loader = UIActivityIndicatorView()
    
    private let topview:UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let textfield: UITextField = {
        let tf = UITextField()
        tf.returnKeyType = .search
        tf.borderStyle = .none
        tf.tintColor = .lightGray
        tf.attributedPlaceholder = NSAttributedString(string: "목적지를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.textColor = .black
        tf.keyboardAppearance = .light
        tf.keyboardType = .default
        tf.backgroundColor = .white
        tf.font = .systemFont(ofSize: 18)
        return tf
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "arrow.backward"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorStyle = .none
        return tv
    }()
    
    private let noResult = UILabel().noResult()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDetail()
        configureLoader()
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        view.backgroundColor = .white
        
        view.addSubview(topview)
        topview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topview.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchButton.heightAnchor.constraint(equalToConstant: 30),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.centerYAnchor.constraint(equalTo: topview.centerYAnchor)
        ])
        
        view.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textfield.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor),
            textfield.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 20),
            textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            textfield.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: topview.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bottomView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func configureDetail(){
        textfield.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        
    }
    
    private func addNoResult(){
        view.addSubview(noResult)
        noResult.translatesAutoresizingMaskIntoConstraints = false
        noResult.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResult.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureLoader(){
        viewModel = SearchViewModel()
        viewModel?.beginning = loaderON
        viewModel?.finishing = loaderOFF
    }
    
    //MARK: - Actions
    
    private func loaderON() {
        view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.tintColor = .gray
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loader.startAnimating()
    }
    
    private func loaderOFF() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.loader.stopAnimating()
            self?.loader.removeFromSuperview()
        }
    }
    
    @objc private func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
}


//MARK: - UITableViewDataSource

extension SearchController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.count == 0{
            addNoResult()
        }else{
            noResult.removeFromSuperview()
        }
        return viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as! SearchCell
        cell.backgroundColor = .white
        cell.namelabel.text = viewModel?.name(index: indexPath.row)
        cell.addressLabel.text = viewModel?.address(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//MARK: - UITableViewDelegate
// when it is tapped
extension SearchController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let lating = viewModel?.lating(index: indexPath.row) else {return}
        guard let avenue = viewModel?.oldAdress(index: indexPath.row) else {return}
        delegate?.markOnTheMap(location: lating, avenue: avenue)
        print(viewModel?.address(index: indexPath.row))
        print(viewModel?.oldAdress(index: indexPath.row))
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension SearchController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        textfield.attributedPlaceholder = nil
        keyboard = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {return false}
        viewModel?.fetch(searchText: text)
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UIScrollViewDelegate
extension SearchController:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if keyboard{
            view.endEditing(true)
            keyboard = false
        }
    }
}

