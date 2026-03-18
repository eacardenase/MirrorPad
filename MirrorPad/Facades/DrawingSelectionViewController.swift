/// Copyright (c) 2026 Razeware LLC
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

public protocol DrawingSelectionViewControllerDelegate: AnyObject {
  func drawingSelectionViewControllerDidCancel(
    _ viewController: DrawingSelectionViewController
  )

  func drawingSelectionViewController(
    _ viewController: DrawingSelectionViewController,
    didSelectView view: UIView
  )
}

public final class DrawingSelectionViewController: UIViewController {
  // MARK: - Properties

  public var delegate: DrawingSelectionViewControllerDelegate?

  private var entireDrawing: UIView
  private var inputDrawing: UIView
  private var selectedDrawing: UIView

  private lazy var cancelButton: UIButton = {
    let button = UIButton(type: .system)

    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Cancel", for: .normal)
    button.tintColor = .white
    button.backgroundColor = .systemGray
    button.addTarget(
      self,
      action: #selector(cancelButtonTapped),
      for: .touchUpInside
    )

    button.layer.cornerRadius = 8
    button.contentEdgeInsets = UIEdgeInsets(
      top: 8,
      left: 16,
      bottom: 8,
      right: 16
    )

    return button
  }()

  private lazy var shareButton: UIButton = {
    let button = UIButton(type: .system)

    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Share", for: .normal)
    button.tintColor = .white
    button.backgroundColor = .systemRed
    button.addTarget(
      self,
      action: #selector(shareButtonTapped),
      for: .touchUpInside
    )

    button.layer.cornerRadius = 8
    button.contentEdgeInsets = UIEdgeInsets(
      top: 8,
      left: 16,
      bottom: 8,
      right: 16
    )

    return button
  }()

  private lazy var expandContractButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(resource: .expandArrows).withRenderingMode(
      .alwaysOriginal
    )

    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(image, for: .normal)
    button.addTarget(
      self,
      action: #selector(expandContractButtonTapped),
      for: .touchUpInside
    )

    return button
  }()

  // MARK: - Object Lifecycle

  public init(
    entireDrawing: UIView,
    inputDrawing: UIView,
    delegate: DrawingSelectionViewControllerDelegate
  ) {
    self.entireDrawing = entireDrawing
    self.inputDrawing = inputDrawing
    self.selectedDrawing = inputDrawing
    self.delegate = delegate

    super.init(nibName: nil, bundle: nil)

    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - View Lifecycle

  public override func loadView() {
    view = OutlineView()

    setupViews()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    var selectedFrame = selectedDrawing.frame

    if selectedDrawing === inputDrawing {
      selectedFrame = selectedDrawing.convert(
        selectedDrawing.frame,
        to: entireDrawing.superview
      )
    }

    view.frame = selectedFrame
  }

  // MARK: - Actions

  @objc func cancelButtonTapped(_ sender: UIButton) {
    delegate?.drawingSelectionViewControllerDidCancel(self)
  }

  @objc func shareButtonTapped(_ sender: UIButton) {
    print(selectedDrawing)

    delegate?.drawingSelectionViewController(
      self,
      didSelectView: selectedDrawing
    )
  }

  @objc func expandContractButtonTapped(_ sender: UIButton) {
    toggleSelectedDrawing()
    animateViewBounds()
  }

  private func toggleSelectedDrawing() {
    if selectedDrawing === inputDrawing {
      selectedDrawing = entireDrawing
    } else {
      selectedDrawing = inputDrawing
    }
  }

  private func animateViewBounds() {
    let newBounds = selectedDrawing.bounds

    UIView.animateKeyframes(
      withDuration: 0.33,
      delay: 0.0,
      options: .layoutSubviews,
      animations: { [weak self] in
        self?.view.bounds = newBounds
      },
      completion: { [weak self] _ in
        self?.updateExpandContractButtonTransform()
      }
    )
  }

  private func updateExpandContractButtonTransform() {
    if selectedDrawing === inputDrawing {
      expandContractButton.transform = CGAffineTransform.identity
    } else {
      expandContractButton.transform = CGAffineTransform(rotationAngle: .pi)
    }
  }
}

// MARK: - Helpers

extension DrawingSelectionViewController {
  private func setupViews() {

    let stackView = UIStackView(arrangedSubviews: [cancelButton, shareButton])

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 24

    view.addSubview(stackView)
    view.addSubview(expandContractButton)

    // stackView
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])

    // expandContractButton
    NSLayoutConstraint.activate([
      expandContractButton.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -8
      ),
      expandContractButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -8
      ),
    ])
  }
}
