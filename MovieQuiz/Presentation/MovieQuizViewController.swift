import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak private var previewImage: UIImageView!
    
    @IBOutlet weak private var counterLabel: UILabel!
    
    @IBOutlet weak private var questionLabel: UILabel!
    
    private let questions: [QuizQuestion] = getQuestions()

    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        checkAnswer(answer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        checkAnswer(answer: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configurePreviewImage()
        configureLabels()
        startQuiz()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.previewImage.layer.borderWidth = 0
        }
        
    }
    
    private func checkAnswer(answer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = currentQuestion.correctAnswer == answer
        if isCorrect {
            correctAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
      )
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 {
          let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен",
            text: "Ваш результат: \(correctAnswers)/10",
            buttonText: "Сыграть ещё раз"
          )
          show(quiz: viewModel)
      } else {
        currentQuestionIndex += 1
        let nextQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: nextQuestion)
          
          show(quiz: viewModel)
      }
    }
    
    private func startQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        if let firstQuestion = questions.first   {
            show(quiz: convert(model: firstQuestion))
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.startQuiz()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

struct QuizQuestion {	
  let image: String
  let text: String
  let correctAnswer: Bool
}

struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

private func getQuestions() -> [QuizQuestion] {
    return [
        QuizQuestion(
                   image: "The Godfather",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: true),
               QuizQuestion(
                   image: "The Dark Knight",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: true),
               QuizQuestion(
                   image: "Kill Bill",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: true),
               QuizQuestion(
                   image: "The Avengers",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: true),
               QuizQuestion(
                   image: "Deadpool",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: true),
               QuizQuestion(
                   image: "The Green Knight",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: true),
               QuizQuestion(
                   image: "Old",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: false),
               QuizQuestion(
                   image: "The Ice Age Adventures of Buck Wild",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: false),
               QuizQuestion(
                   image: "Tesla",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: false),
               QuizQuestion(
                   image: "Vivarium",
                   text: "Рейтинг этого фильма больше чем 6?",
                   correctAnswer: false)
    ]
}
