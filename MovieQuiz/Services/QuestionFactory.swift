import UIKit

final class QuestionFactory : QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            let imageData = getMovieImage(for: movie)
            
            let rating = Float(movie.rating) ?? 00
            
            let goalRating: Float = Float.random(in: 6.0...10.0)
            let text = String(localized: "is_rating_more") + "\(Int(goalRating))?"
            let correctAnswer = rating > goalRating
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let popularMovies):
                    self.movies = popularMovies.items
                    self.delegate?.didLoadDataFromServer()
                    
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    // TODO get rid of Data(contentsOf: movie.resizedImageURL) it handles incorrect url very poorly
    private func getMovieImage(for movie: MostPopularMovie) -> Data {
        do {
            return try Data(contentsOf: movie.resizedImageURL)
        } catch {
            print("Failed to load movie image \(movie.title)")
            return createTitlePlaceholder(for: movie)
        }
    }
    
    private func createTitlePlaceholder(for movie: MostPopularMovie) -> Data {
        let placeholderImage = createMovieTitleImage(movieTitle: movie.title)
        return placeholderImage.pngData() ?? Data()
    }
    
    private func createMovieTitleImage(movieTitle: String) -> UIImage {
        let size = CGSize(width: 200, height: 300)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            UIColor(white: 0.9, alpha: 1.0).setStroke()
            context.stroke(CGRect(origin: .zero, size: size).insetBy(dx: 0.5, dy: 0.5))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor.darkGray,
                .paragraphStyle: paragraphStyle
            ]
            
            let textRect = CGRect(
                x: 20,
                y: size.height / 2 - 40,
                width: size.width - 40,
                height: 80
            )
            
            (movieTitle as NSString).draw(in: textRect, withAttributes: attributes)
            
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
            if let filmIcon = UIImage(systemName: "film", withConfiguration: config)?
                .withTintColor(.lightGray, renderingMode: .alwaysOriginal) {
                let iconRect = CGRect(
                    x: (size.width - 30) / 2,
                    y: 40,
                    width: 30,
                    height: 30
                )
                filmIcon.draw(in: iconRect)
            }
        }
    }
}
