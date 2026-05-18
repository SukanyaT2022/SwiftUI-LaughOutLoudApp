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
    }
}
