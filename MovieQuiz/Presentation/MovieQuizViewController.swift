import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet weak private var previewImage: UIImageView!
    
    @IBOutlet weak private var counterLabel: UILabel!
    
    @IBOutlet weak private var questionLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let alertPresenter = AlertPresenter()
    private let statisticService: StatisticServiceProtocol = StatisticService()
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        checkAnswer(answer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        checkAnswer(answer: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self)
    
        configurePreviewImage()
        configureLabels()
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
    
    private func configurePreviewImage() {
        previewImage.layer.cornerRadius = 20
    }
    
    private func configureLabels() {
        questionLabel.numberOfLines = 0
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
            image: UIImage(named: model.image) ?? UIImage(),
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
          title: "Этот раунд окончен",
          text: text,
          buttonText: "Сыграть ещё раз"
        )
        show(quiz: viewModel)
    }
    
    private func startQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = result.toAlertModel { [weak self] in
            if let controller =  self { controller.startQuiz() }
        }
        
        alertPresenter.show(alertModel) { alert in
            self.present(alert, animated: true, completion: nil)
        }
    }
}
