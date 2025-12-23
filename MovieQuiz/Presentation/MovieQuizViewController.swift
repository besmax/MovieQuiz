import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private let activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak private var previewImage: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let alertPresenter = AlertPresenter()
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        disableButtons()
        checkAnswer(answer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        disableButtons()
        checkAnswer(answer: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        configurePreviewImage()
        configureLabels()
        configureActivityIndicator()
        startQuiz()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
                
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoading()
        previewImage.isHidden = false
        counterLabel.isHidden = false
        questionLabel.isHidden = false
        
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showError(message: error.localizedDescription)
    }
    
    private func configurePreviewImage() {
        previewImage.layer.cornerRadius = 20
    }
    
    private func configureLabels() {
        questionLabel.numberOfLines = 0
    }
    
    private func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .ypGreen
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func show(quiz step: QuizStepViewModel) {
        previewImage.image = step.image
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        let color = isCorrect ? UIColor.ypGreen : UIColor.ypRed
        
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.borderColor = color.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.previewImage.layer.borderWidth = 0
        }
    }
    
    private func checkAnswer(answer: Bool) {
        if  let currentQuestion = currentQuestion {
            let isCorrect = currentQuestion.correctAnswer == answer
            if isCorrect {
                correctAnswers += 1
            }
            showAnswerResult(isCorrect: isCorrect)}
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
        enableButtons()
    }
    
    private func showQuizResults() {
        let accuracyFormatted = String(format: "%.2f", statisticService.totalAccuracy)
        let bestGame = statisticService.bestGame
        let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
            Средняя точность: \(accuracyFormatted)%
            """
        let viewModel = QuizResultsViewModel(
            title: String(localized: "round_finished"),
            text: text,
            buttonText: String(localized: "play_again")
        )
        show(quiz: viewModel)
    }
    
    private func startQuiz() {
        showLoading()
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.loadData()
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = result.toAlertModel { [weak self] in
            if let controller =  self { controller.startQuiz() }
        }
        
        alertPresenter.show(alertModel) { [weak self] alert in
               self?.present(alert, animated: true, completion: nil)
           }
    }
    
    private func disableButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func enableButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func showLoading() {
        activityIndicator.startAnimating()
        previewImage.isHidden = true
        counterLabel.isHidden = true
        questionLabel.isHidden = true
    }
    
    private func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func showError(message: String) {
        previewImage.isHidden = true
        counterLabel.isHidden = true
        questionLabel.isHidden = true
        hideLoading()
        
        let onButtonClick = { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        let alertAction = AlertAction(title: String(localized: "try_again"), action: onButtonClick)
        
        let alertModel = AlertModel(
            title: String(localized: "error_title"),
            message: message,
            actions: [alertAction]
        )
        
        alertPresenter.show(alertModel) { [weak self] alert in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
