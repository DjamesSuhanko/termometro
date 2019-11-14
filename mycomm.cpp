#include "mycomm.h"
#include <QThread>
#include <QTimer>

MyComm::MyComm(QObject *parent) : QObject(parent)
{
    QTimer *timer = new QTimer(this);
    timer->setInterval(1000);
    //connect(timer,SIGNAL(timeout()),this,SLOT(setRPiTemp()));
    timer->start();
}

void MyComm::start()
{
    this->client  = new QMQTT::Client(QHostAddress("192.168.1.200"), 1883);

    client->setClientId("comparador");
    client->setUsername("dobitaobyte");
    client->setPassword("fsjmr112");

    connect(client,SIGNAL(connected()),this,SLOT(onConnected()));
    connect(client,SIGNAL(disconnected()),this,SLOT(onDisconnected()));
    connect(client,SIGNAL(received(const QMQTT::Message&)),this,SLOT(onReceived(const QMQTT::Message&)));

    client->connectToHost();
}

void MyComm::onConnected()
{
    qDebug() << "connected" << endl;
    client->subscribe("/raspberry/#",0);

}

void MyComm::onDisconnected()
{
    qDebug() << "saiu" << endl;
}

void MyComm::onReceived(const QMQTT::Message &message)
{
    qDebug() << "Message inbox..." << endl;

    QString topic = message.topic();
    QString payload = QString(message.payload());
    double valueDouble = payload.toDouble();

    qDebug() << topic;
    if (topic.contains("/raspberry/rpi1")){
        qDebug() << "RPi 1";
        this->mainPage->findChild<QQuickItem*>("rpi1val")->setProperty("text", payload);

    }
    else if (topic.contains("/raspberry/rpi3")){
        qDebug() << "RPi 3";
        this->mainPage->findChild<QQuickItem*>("rpi3val")->setProperty("text", payload);

    }
    else if (topic.contains("/raspberry/rpi4")){
        qDebug() << "RPi 4";
        this->mainPage->findChild<QQuickItem*>("rpi4val")->setProperty("text", payload);

    }
}

void MyComm::QMLhandler(QObject *externalMainPage)
{
    this->mainPage = externalMainPage;
}

void MyComm::setRPiTemp()
{
    QString output;
    double outputDouble;
    qDebug() << "Fire!" << endl;
    QProcess getTemp;
    QString program = "vcgencmd";
    QString params  = "measure_temp";
    getTemp.start(program,params.split(" "));

    while (getTemp.waitForReadyRead(1000)){
        output       = getTemp.readAllStandardOutput();
        output       = output.split("=").at(1);
        outputDouble = output.split("'").at(0).toDouble() / 100;

        qDebug() << outputDouble;
        qDebug() << output << endl;
    }


    this->mainPage->findChild<QQuickItem*>("labelTempRPi")->setProperty("text", output);
    this->mainPage->findChild<QQuickItem*>("progressBarRPi")->setProperty("value", outputDouble);
}

void MyComm::shutdown()
{
    qDebug() << "shutdown..." << endl;
    this->client->disconnect();
}
