import QtQuick 2.0

Item {
    id : clock
    width: {
        if (ListView.view && ListView.view.width >= 320)
            return ListView.view.width / Math.floor(ListView.view.width / 320.0);
        else
            return 320;
    }

    height: {
        if (ListView.view && ListView.view.height >= 240)
            return ListView.view.height;
        else
            return 240;
    }

    property alias city: cityLabel.text
    property int hours
    property int minutes
    property int seconds
    property real shift
    property bool night: false
    property bool internationalTime: true //Unset for local time
    property real pointToNext: 3.375
    property real tara: 180+45+pointToNext
    property real actualPressure: tara
    property string grausCelsius: " °C"
    property string rawValue: "0.0"

    Text {
        id: rpi
        text: "1"
    }

    function timeChanged() {
        //var date = new Date;
        //measurement.text = shift + grausCelsius
        //cityLabel.text = shift == 0.02 ? "RPi 3 Joia" : city
        //console.log(rpi1val.text)
        //rpi1val.text = "batata"
        //console.log(rpi1val.text)
        rawValue = cityLabel.text == "RPi 1" ? rpi1val.text + grausCelsius : (cityLabel.text == "RPi 3" ? rpi3val.text + grausCelsius : rpi4val.text + grausCelsius)
        //console.log(rawValue.split(" ")[0])
        measurement.text = rawValue
        actualPressure = tara+parseInt(rawValue.split(" ")[0]) * 3.375

    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: clock.timeChanged()
    }

    Item {
        anchors.centerIn: parent
        width: 320; height: 240

        Text {
            id: externalValue
            objectName: "externalValue"
            text: "0.01"
        }

        Text {
            id: measurement
            y: -30
            x: 92
            color: "white"
            font.family: "Helvetica"
            font.bold: true; font.pixelSize: 30
            style: Text.Raised; styleColor: "black"
            text:  shift + grausCelsius
        }

        Image {
            width: 240
            height: 240
            id: background
            source: "termometro.png"
            visible: true
        }


        Image {
            id: pointer
            width: 27.5/1.3
            height: 132/1.3+10
            x:108
            y:46
            antialiasing: true
            source: "second.png"

            transform: Rotation {
                id: pointerRotation
                origin.x: 10.5; origin.y: 132/1.33-10.35;
                angle: actualPressure //seconds * 6
                Behavior on angle {
                    SpringAnimation { spring: 6; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            x:108
            y:124
            //anchors.centerIn: background
            source: "center.png"
        }

        Text {
            id: cityLabel
            y: 180;
            x: 92
            color: "white"
            font.family: "Helvetica"
            font.bold: true; font.pixelSize: 16
            style: Text.Raised; styleColor: "black"
        }
    }
}
