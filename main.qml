import QtQuick 2.12
import QtQuick.Controls 2.5
import "content" as Content

ApplicationWindow {
    visible: true
    width: 800
    height: 480
    title: qsTr("Comparativo de temperatura")

    //esses valores serão manipulados em MyComm.cpp
    Text {
        id: rpi1val
        objectName: "rpi1val"
        text: "0.01"
    }
    Text {
        id: rpi3val
        objectName: "rpi3val"
        text: "0.01"
    }
    Text {
        id: rpi4val
        objectName: "rpi4val"
        text:  "0.01"
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page1Form {
            Rectangle {
                id: root
                width: 800; height: 480
                color: "#202020"

                Text {
                    objectName: "tShift"
                    id: tShift
                    text: "0.01"
                }

                ListView {
                    objectName: "clockview"
                    id: clockview
                    anchors.fill: parent
                    orientation: ListView.Horizontal
                    cacheBuffer: 2000
                    snapMode: ListView.SnapOneItem
                    highlightRangeMode: ListView.ApplyRange

                    //encapsula o elemento clock, com a modificação das propriedades city e shift
                    delegate: Content.Clock { city: cityName; shift: timeShift }
                    model: ListModel {
                        id: treta
                        ListElement {
                            cityName: "RPi 3"
                            timeShift: "0.01"
                        }
                        ListElement { cityName: "RPi 4"; timeShift: "0.01"}
                        ListElement { cityName: "RPi 1"; timeShift: "0.01"}
                    }
                }
/*
                Image {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    source: "arrow.png"
                    rotation: -90
                    opacity: clockview.atXBeginning ? 0 : 0.5
                    Behavior on opacity { NumberAnimation { duration: 500 } }
                }

                Image {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    source: "arrow.png"
                    rotation: 90
                    opacity: clockview.atXEnd ? 0 : 0.5
                    Behavior on opacity { NumberAnimation { duration: 500 } }
                }
                */

            }
        }

        Page2Form {
        }
    }

    //footer do applicationWindow
    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Temperaturas")
        }
        TabButton {
            text: qsTr("Sem uso...")
        }
    }
}
