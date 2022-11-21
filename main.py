import tweepy
import keys
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from random import randrange
from email.message import EmailMessage
import ssl
import smtplib
import schedule
import time


def api():
    auth = tweepy.OAuthHandler(keys.api_key, keys.api_secret)
    auth.set_access_token(keys.access_token, keys.access_token_secret)
    return tweepy.API(auth)


def hasTweets():
    db = firestore.client()
    tweetsCollection = db.collection(u'Tweets')
    tweetsStream = tweetsCollection.stream()
    tweetsUnsend = []
    for tweet in tweetsStream:
        if not tweet.to_dict()['sent']:
            tweetsUnsend.append(
                {'id': tweet.id, 'tweet': tweet.to_dict()['tweet']})
    if not len(tweetsUnsend):
        return False
    else:
        return tweetsUnsend, tweetsCollection


def getTweet():
    tweetsUnsend, tweetsCollection = hasTweets()
    tweet = tweetsUnsend.pop(randrange(len(tweetsUnsend)))
    tweetsCollection.document(tweet['id']).update({'sent': True})
    return tweet['tweet']


def sendEmail(tweet):
    subject = 'Snitch Bot'
    if tweet:
        body = f'🚨 {tweet} 🚨' if 'Snitch Bot was unable to tweet!' in tweet else f'''
        Snitch Bot just tweeted:
        "{tweet}"
        '''
    else:
        body = f'''
    Snitch Bot run out of tweets! Feel free to add more 😈
    '''
    email = EmailMessage()
    email['From'] = keys.gmail
    email['To'] = keys.gmail
    email['subject'] = subject
    email.set_content(body)
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp:
        smtp.login(keys.gmail, keys.gmail_password)
        smtp.sendmail(keys.gmail, keys.gmail, email.as_string())


def sendTweet():
    api = api()
    tweet = getTweet()
    try:
        api.update_status(tweet)
        sendEmail(tweet)
    except:
        sendEmail('Snitch Bot was unable to tweet!')


schedule.every(1200).to(1440).minutes.do(sendTweet)


def main():
    cred = credentials.Certificate(keys.firebase_credentials_path)
    firebase_admin.initialize_app(cred)
    while 1:
        if not hasTweets():
            sendEmail(False)
            break
        schedule.run_pending()
        time.sleep(1)


if __name__ == '__main__':
    main()
