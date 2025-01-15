// question_service.dart

class QuestionService {
  // ...

  Future<List<dynamic>> getQuestions({
    String filter = 'all',
    String sort = 'date',
  }) async {
    // 1. Fetch all questions
    final snapshot = await _firestore.collection('questions').get();
    var questions = snapshot.docs.map((doc) => Question.fromMap(doc.data())).toList();

    // 2. Apply filtering
    questions = _filterQuestions(questions, filter);

    // 3. Apply sorting
    questions = _sortQuestions(questions, sort);

    return questions;
  }

  List<dynamic> _filterQuestions(List<dynamic> questions, String filter) {
    switch (filter) {
      case 'category1':
        return questions.where((question) => question.category == 'category1').toList();
    // ... add more filter cases
      default:
        return questions;
    }
  }

  List<dynamic> _sortQuestions(List<dynamic> questions, String sort) {
    switch (sort) {
      case 'date':
        questions.sort((a, b) => b.askedDate.compareTo(a.askedDate)); // Sort by askedDate in descending order
        break;
      case 'popularity':
        questions.sort((a, b) => b.votes.compareTo(a.votes)); // Sort by votes in descending order
        break;
    // ... add more sort cases
    }
    return questions;
  }

  Future<void> upvoteAnswer(String questionId, String answerId) async {
    try {
      final questionRef = _firestore.collection('questions').doc(questionId);
      final answerRef = questionRef.collection('answers').doc(answerId);

      // Increment the votes count
      await answerRef.update({'votes': FieldValue.increment(1)});
    } catch (e) {
      // Handle error
      print('Error upvoting answer: $e');
    }
  }

  Future<void> downvoteAnswer(String questionId, String answerId) async {
    try {
      final questionRef = _firestore.collection('questions').doc(questionId);
      final answerRef = questionRef.collection('answers').doc(answerId);

      // Decrement the votes count
      await answerRef.update({'votes': FieldValue.increment(-1)});
    } catch (e) {
      // Handle error
      print('Error downvoting answer: $e');
    }
  }

// ... other methods ...
}