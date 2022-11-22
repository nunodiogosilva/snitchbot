import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snitchbotui/variables.dart';

Stream<QuerySnapshot>? _tweetsStream;
CollectionReference tweets = FirebaseFirestore.instance.collection('Tweets');

void getTweets(bool sent) {
  _tweetsStream = tweets.where('sent', isEqualTo: sent).snapshots();
}

Stream<QuerySnapshot<Object?>>? getTweetsStream(bool sent) {
  getTweets(sent);
  return _tweetsStream;
}

Future<void> addTweet(tweet, context) async {
  try {
    await tweets.add({
      'tweet': tweet,
      'sent': false,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Successfully added Tweet: $tweet",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Failed to add Tweet: $error",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> editTweet(tweetId, tweet, context) async {
  try {
    await tweets.doc(tweetId).update(
      {'tweet': tweet},
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Successfully edited Tweet: $tweet",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Failed to edit Tweet: $error",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> editTweetStatus(tweetId, status, context) async {
  try {
    await tweets.doc(tweetId).update(
      {'sent': status},
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Successfully edited Tweet Status: $status",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Failed to edit Tweet: $error",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> deleteTweet(tweetId, context) async {
  try {
    await tweets.doc(tweetId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Successfully deleted Tweet",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff151518),
        content: SizedBox(
          height: snackBarHeight,
          child: Text(
            "Failed to delete Tweet: $error",
            style: TextStyle(
              fontSize: snackBarFontSize,
              color: const Color(0xFFEFEFEF),
            ),
          ),
        ),
      ),
    );
  }
}
