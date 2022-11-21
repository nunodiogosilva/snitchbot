import tweepy
import keys
from random import randrange
from email.message import EmailMessage
import ssl
import smtplib
import schedule
import time

tweets = ['É mais fácil separar a água do vinho que a hipocrisia da verdade no julgamento das ações humanas.',
          'O que mais odeio é gente complicada e preconceituosa, hipocrisia e ser acordado. Nada consegue ser pior do que isso.',
          'A mentira é muita vezes tão involuntária como a respiração.',
          'Assim como uma gota de veneno compromete um balde inteiro, também a mentira, por menor que seja, estraga toda a nossa vida.',
          'Existe muito pedaço de vidro a tentar disfarçar-se de diamante.',
          'Neste momento a rapariga já se deve estar a coçar toda, parece que tem pulga',
          'Uma mentira dá uma volta inteira ao mundo antes mesmo de a verdade ter oportunidade de se vestir.',
          'Nenhum mentiroso tem uma memória suficientemente boa para ser um mentiroso de êxito.',
          'O verdadeiro Snitch chegou e vem com tudo!',
          'Inimigos honestos são mais dignos de confiança do que "amigos" oportunistas.',
          'A falsidade é um caminho perigoso escolhido apenas por pessoas que não conseguem ter mérito no que fazem.',
          'O oportunista é um falso herói, engana os inocentes e a boa fé destrói.',
          'Muito cuidado na estrada da vida, pois há alienados na pista, oportunistas no acostamento, imbecis após a curva e bondosos na via de duplo sentido.',
          'Não fales mal de alguém se não tens certeza, e se tiveres, pergunta-te por que estás a falar sobre isso.',
          'Cuidado com os olhos atentos daqueles que têm a inveja como primazia e o oportunismo como farol.',
          'Hoje lutam contra um inimigo invisível e que se utiliza de uma situação oportunista para a sua disseminação e evolução. Será um longo aprendizado para todos...',
          'Não tenhas medo do inimigo que te ataca, mas sim do falso amigo que te abraça.'
          'É melhor ser verdadeiro e solitário do que viver em falsidade e estar sempre acompanhado.',
          'Só eu sei quem eu sou...',
          'Se pararem de dizer mentiras a meu respeito, eu paro de dizer verdades a vosso respeito.',
          'O carnaval já passou e as máscaras continuam a cair.',
          'Cortei a relva e as cobras sairam!',
          'Se nos julgamos melhores que os outros, por que esperamos deles melhores atitudes que as nossas?',
          'Há um desamor nas pessoas, uma enorme falta de tudo, valores, princípios, atitudes, respeito, coerência, seriedade, responsabilidade, carácter, moral... Isso é muito triste!',
          'Pessoas elevadas falam de ideias. Pessoas medianas falam de factos. Pessoas vulgares falam de pessoas.',
          'Pessoas falsas merecem pensamentos verdadeiros, amigos somente a retribuição pela sua amizade eterna.',
          'O boato é um vírus que nasce dos incapazes e que se prolifera nos imbecis.',
          'Não te abras com teu "amigo" que ele um outro amigo tem. E o amigo do teu amigo possui amigos também...',
          'Assim como árvores podres, amizades falsas tombarão também.',
          'Se te revelares eu me revelarei também.',
          'O amigo deve ser como o dinheiro, cujo valor já conhecemos antes de termos necessidade dele.',
          'A única forma de se viver livre de amizades falsas é não tendo dinheiro.']


def api():
    auth = tweepy.OAuthHandler(keys.api_key, keys.api_secret)
    auth.set_access_token(keys.access_token, keys.access_token_secret)
    return tweepy.API(auth)


def sendEmail(tweet):
    gmail = keys.gmail
    password = keys.gmail_password
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
    email['From'] = gmail
    email['To'] = gmail
    email['subject'] = subject
    email.set_content(body)
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp:
        smtp.login(gmail, password)
        smtp.sendmail(gmail, gmail, email.as_string())


def sendTweet():
    api = api()
    tweet = tweets.pop(randrange(len(tweets)))
    try:
        api.update_status(tweet)
        sendEmail(tweet)
    except:
        sendEmail('Snitch Bot was unable to tweet!')


schedule.every(1200).to(1440).minutes.do(sendTweet)


def main():
    while 1:
        if not len(tweets):
            sendEmail(False)
            break
        schedule.run_pending()
        time.sleep(1)


if __name__ == '__main__':
    main()
