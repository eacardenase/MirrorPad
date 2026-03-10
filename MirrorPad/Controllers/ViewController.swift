/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

public class ViewController: UIViewController {

  // MARK: - Properties

  public var drawViewContainer = UIView()
  public let inputDrawView = DrawView()
  public let topRightDrawView = DrawView()
  public let bottomLeftDrawView = DrawView()
  public let bottomRightDrawView = DrawView()
  public let horizontalDivider: UIView = {
    let view = UIView()

    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemBlue
    view.alpha = 0.25

    return view
  }()
  public let verticalDivider: UIView = {
    let view = UIView()

    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemBlue
    view.alpha = 0.25

    return view
  }()

  let spacerButton = UIBarButtonItem(systemItem: .flexibleSpace)

  public lazy var shareButton = UIBarButtonItem(
    title: "Share",
    style: .plain,
    target: self,
    action: #selector(sharePressed)
  )

  public lazy var clearButton = UIBarButtonItem(
    title: "Clear",
    style: .plain,
    target: self,
    action: #selector(clearPressed)
  )

  public lazy var animateButton = UIBarButtonItem(
    title: "Animate",
    style: .plain,
    target: self,
    action: #selector(animatePressed)
  )

  public lazy var mirrorDrawViews = [
    topRightDrawView, bottomLeftDrawView, bottomRightDrawView,
  ]

  // MARK: - View Lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.isHidden = true
    navigationController?.isToolbarHidden = false

    setupViews()

    toolbarItems = [
      shareButton,
      spacerButton,
      clearButton,
      spacerButton,
      animateButton,
    ]

  }

  // MARK: - Actions

  @objc public func animatePressed(_ sender: UIBarButtonItem) {
    mirrorDrawViews.forEach { $0.copyLines(from: inputDrawView) }
    mirrorDrawViews.forEach { $0.animate() }

    inputDrawView.animate()
  }

  @objc public func clearPressed(_ sender: UIBarButtonItem) {
    inputDrawView.clear()
    mirrorDrawViews.forEach { $0.clear() }
  }

  @objc public func sharePressed(_ sender: UIBarButtonItem) {
    print(#function)
  }
}

// MARK: - Helpers

extension ViewController {

  private func setupViews() {
    view.backgroundColor = .systemBackground

    drawViewContainer.translatesAutoresizingMaskIntoConstraints = false
    inputDrawView.translatesAutoresizingMaskIntoConstraints = false
    topRightDrawView.translatesAutoresizingMaskIntoConstraints = false
    bottomLeftDrawView.translatesAutoresizingMaskIntoConstraints = false
    bottomRightDrawView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(drawViewContainer)
    view.addSubview(horizontalDivider)
    view.addSubview(verticalDivider)

    drawViewContainer.addSubview(inputDrawView)
    drawViewContainer.addSubview(topRightDrawView)
    drawViewContainer.addSubview(bottomLeftDrawView)
    drawViewContainer.addSubview(bottomRightDrawView)

    // drawViewContainer
    NSLayoutConstraint.activate([
      drawViewContainer.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor
      ),
      drawViewContainer.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor
      ),
      drawViewContainer.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor
      ),
      drawViewContainer.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor
      ),

    ])

    // inputDrawView
    NSLayoutConstraint.activate([
      inputDrawView.topAnchor.constraint(equalTo: drawViewContainer.topAnchor),
      inputDrawView.leadingAnchor.constraint(
        equalTo: drawViewContainer.leadingAnchor
      ),
      inputDrawView.widthAnchor.constraint(
        equalTo: topRightDrawView.widthAnchor
      ),
      inputDrawView.heightAnchor.constraint(
        equalTo: bottomLeftDrawView.heightAnchor
      ),
    ])

    // topRightDrawView
    NSLayoutConstraint.activate([
      topRightDrawView.topAnchor.constraint(
        equalTo: inputDrawView.topAnchor
      ),
      topRightDrawView.leadingAnchor.constraint(
        equalTo: inputDrawView.trailingAnchor
      ),
      topRightDrawView.trailingAnchor.constraint(
        equalTo: drawViewContainer.trailingAnchor
      ),
      topRightDrawView.widthAnchor.constraint(
        equalTo: inputDrawView.widthAnchor
      ),
    ])

    // bottomLeftDrawView
    NSLayoutConstraint.activate([
      bottomLeftDrawView.topAnchor.constraint(
        equalTo: inputDrawView.bottomAnchor
      ),
      bottomLeftDrawView.leadingAnchor.constraint(
        equalTo: drawViewContainer.leadingAnchor
      ),
      bottomLeftDrawView.bottomAnchor.constraint(
        equalTo: drawViewContainer.bottomAnchor
      ),
      bottomLeftDrawView.widthAnchor.constraint(
        equalTo: bottomRightDrawView.widthAnchor
      ),
      bottomLeftDrawView.heightAnchor.constraint(
        equalTo: inputDrawView.heightAnchor
      ),
    ])

    // bottomRightDrawView
    NSLayoutConstraint.activate([
      bottomLeftDrawView.topAnchor.constraint(
        equalTo: topRightDrawView.bottomAnchor
      ),
      bottomRightDrawView.leadingAnchor.constraint(
        equalTo: bottomLeftDrawView.trailingAnchor
      ),
      bottomRightDrawView.trailingAnchor.constraint(
        equalTo: drawViewContainer.trailingAnchor
      ),
      bottomRightDrawView.bottomAnchor.constraint(
        equalTo: drawViewContainer.bottomAnchor
      ),
      bottomRightDrawView.heightAnchor.constraint(
        equalTo: bottomLeftDrawView.heightAnchor
      ),
      bottomRightDrawView.widthAnchor.constraint(
        equalTo: bottomLeftDrawView.widthAnchor
      ),
    ])

    // horizontalDivider
    NSLayoutConstraint.activate([
      horizontalDivider.centerYAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.centerYAnchor
      ),
      horizontalDivider.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor
      ),
      horizontalDivider.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor
      ),
      horizontalDivider.heightAnchor.constraint(equalToConstant: 2),
    ])

    // verticalDivider
    NSLayoutConstraint.activate([
      verticalDivider.centerXAnchor.constraint(
        equalTo: view.centerXAnchor
      ),
      verticalDivider.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor
      ),
      verticalDivider.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor
      ),
      verticalDivider.widthAnchor.constraint(equalToConstant: 2),
    ])
  }

}
