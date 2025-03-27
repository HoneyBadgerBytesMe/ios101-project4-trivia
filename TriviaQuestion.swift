//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Decodable {
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
        case category
    }
}

struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

class TriviaQuestionService {
    private let baseURL = "https://opentdb.com/api.php"
    
    func fetchQuestions(amount: Int = 5, completion: @escaping ([TriviaQuestion]?) -> Void) {
        guard let url = URL(string: "\(baseURL)?amount=\(amount)&type=multiple") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                completion(decodedResponse.results)
            } catch {
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
