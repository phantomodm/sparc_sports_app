const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Award points for creating a post
exports.onPostCreate = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snap, context) => {
    const post = snap.data();
    const userId = post.author.userId;
    await updateUserReputation(userId, 10); // Award 10 points
  });

// Award points for creating a comment
exports.onCommentCreate = functions.firestore
  .document('comments/{commentId}')
  .onCreate(async (snap, context) => {
    const comment = snap.data();
    const userId = comment.author.userId;
    await updateUserReputation(userId, 5); // Award 5 points
  });

// Award points for creating an answer
exports.onAnswerCreate = functions.firestore
  .document('answers/{answerId}')
  .onCreate(async (snap, context) => {
    const answer = snap.data();
    const userId = answer.author.userId;
    await updateUserReputation(userId, 8); // Award 8 points
  });

// Award points for receiving an upvote on an answer
exports.onAnswerUpvote = functions.firestore
  .document('answers/{answerId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();
    if (newValue.votes > previousValue.votes) {
      const userId = newValue.author.userId;
      await updateUserReputation(userId, 2); // Award 2 points
    }
  });

// Deduct points for receiving a downvote on an answer
exports.onAnswerDownvote = functions.firestore
  .document('answers/{answerId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();
    if (newValue.votes < previousValue.votes) {
      const userId = newValue.author.userId;
      await updateUserReputation(userId, -1); // Deduct 1 point
    }
  });

async function updateUserReputation(userId, points) {
  const userRef = admin.firestore().collection('users').doc(userId);
  await userRef.update({
    reputation: admin.firestore.FieldValue.increment(points),
  });
}