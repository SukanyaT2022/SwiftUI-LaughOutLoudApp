//
//  FavouriteJokeFirestoreService.swift
//  DailyJoke
//

import Foundation
import FirebaseFirestore

/// Writes liked jokes to Firestore using `arrayUnion` on `favJokeData`, matching maps with `id`, `question`, `answer`.
enum FavouriteJokeFirestoreService {
    private static let db = Firestore.firestore()

    /// Change `collectionName` if your document lives under a different collection in the Firebase console.
    private static let collectionName = "favouriteJokes"
    private static let documentId = "StoreFavJoke"
    private static let arrayField = "favJokeData"

    private static var docRef: DocumentReference {
        db.collection(collectionName).document(documentId)
    }
    
//func apend joke will add save on firebase
    /// Appends one liked joke. Duplicate maps (same id/question/answer) are ignored by Firestore `arrayUnion`.
    static func appendLikedJoke(_ joke: Joke, completion: ((Error?) -> Void)? = nil) {
        let entry: [String: Any] = [
            "id": joke.id,
            "question": joke.question,
            "answer": joke.answer
        ]
//            ..setData from firebase bring data from array in firebase to xcode
        docRef.setData(
            [arrayField: FieldValue.arrayUnion([entry])],
            merge: true
        ) { error in
            if let error {
                print("FavouriteJokeFirestoreService append failed: \(error.localizedDescription)")
            }
            completion?(error)
        }
    }//close func

    
    //func get joke from firebase
    /// Fetches the favourites array from the single document and parses it into `[Joke]`.
    /// get data from firebase and give joke array
    static func getJokes(completion: @escaping (Result<[Joke], Error>) -> Void) {
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data() else {
                // No document yet; treat as empty favourites
                completion(.success([]))
                return
            }

            let rawArray = data[arrayField] as? [[String: Any]] ?? []

            let jokes: [Joke] = rawArray.compactMap { dict in
                guard
                    let question = dict["question"] as? String,
                    let answer = dict["answer"] as? String
                else { return nil }
                return Joke(question: question, answer: answer)
            }

            completion(.success(jokes))
        }
    }//end save joke func
    
    //func  delete joke from firebase
    static func deleteJoke(_ joke: Joke, completion: @escaping (Result<Void, Error>) -> Void) {
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data() else {
                completion(.success(()))
                return
            }

            var rawArray = data[arrayField] as? [[String: Any]] ?? []

            rawArray.removeAll { dict in
                let question = dict["question"] as? String
                let answer = dict["answer"] as? String
                return question == joke.question && answer == joke.answer
            }
//below after delete remove all then we update below
            docRef.setData([arrayField: rawArray]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }// end joke func
}
