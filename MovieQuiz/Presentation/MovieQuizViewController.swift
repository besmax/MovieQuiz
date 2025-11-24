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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
            
        if let firstQuestion = questions.first   {
            show(quiz: convert(model: firstQuestion))
        }
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        previewImage.image = step.image
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        let color = isCorrect ? UIColor.YpGreen : UIColor.YpRed
        
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 1
        previewImage.layer.borderColor = color.cgColor
    }
    
    private func checkAnswer(answer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = currentQuestion.correctAnswer == answer
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
      )
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

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
