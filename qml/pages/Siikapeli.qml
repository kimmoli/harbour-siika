import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0 as Sensors
import QtMultimedia 5.0 as Media


Page {
    id: page

    property int score: 0
    property int siika: 0
    property int level: 1


    Media.Audio
    {
        id: playNomNom
        source: "../wavs/nomnom.wav"
    }

    Media.Audio
    {
        id: playSiika
        source: "../wavs/kahenkilonsiika.wav"
    }

    Sensors.Accelerometer
    {
        id: accel
        dataRate: 100
        active: applicationActive && page.status === PageStatus.Active


        onReadingChanged:
        {
            var newX = (pingu.x + calcRoll(accel.reading.x, accel.reading.y, accel.reading.z) * .1)
            var newY = (pingu.y - calcPitch(accel.reading.x, accel.reading.y, accel.reading.z) * .1)


            if (newX < 0)
                newX = 0

            if (newX > page.width - pingu.width)
                newX = page.width - pingu.width

            if (newY < 18)
                newY = 18

            if (newY > page.height - pingu.height)
                newY = page.height - pingu.height

                pingu.x = newX
                pingu.y = newY

            stat.text = "Taso " + level + " - Pisteet " + score

            if (((newX + (pingu.width/2)) > (kala.x)) &&
                ((newX + (pingu.width/2)) < (kala.x + kala.width)) &&
                ((newY + 20) > (kala.y)) &&
                ((newY + 20) < (kala.y + kala.height)))
            {
                timerKala.stop()
                if (siika) // siika tuli
                {
                    playSiika.play()
                    level = level + 1
                }
                else        // joku sintti
                {
                    playNomNom.play()
                }
                pingu.scale = 2
                timerPalauta.start()
                var pisteetKalasta = Math.floor(kala.scale * 10) + (99*siika)
                score = score + pisteetKalasta

                scoretusani.duration = 400
                scoretus.visible =  true
                if (siika)
                {
                    scoretus.text = "TASO " + level
                    scoretus.font.pixelSize = 175
                }
                else
                {
                    scoretus.text = pisteetKalasta
                    scoretus.font.pixelSize = 250
                }

                timerScoretus.start()

                kalaXa.duration = 0
                kalaYa.duration = 0

                kala.x = randomNumber(pingu.width, page.width - pingu.width)
                if (kala.y < page.height/2) // ylempi puolikas, seuraava alas
                    kala.y = randomNumber(page.height/2, page.height - pingu.height)
                else
                    kala.y = randomNumber(30, page.height/2)

                if (timerSiika.running)
                {
                    kala.source = "../pics/sc-fish" + randomNumber(0,5) +".png"
                    kala.scale = 1 + (randomNumber(0,10)/10)
                    siika = 0
                }
                else // kahen kilon siika seuraavaksi
                {
                    kala.source = "../pics/sc-fish6.png"
                    kala.scale = 1
                    siika = 1
                    timerSiika.restart()
                }
                timerKala.restart()

            }

        }
    }


    function randomNumber(from, to)
    {
       return Math.floor(Math.random() * (to - from + 1) + from);
    }

    function calcPitch(x,y,z)
    {
        return -(Math.atan(y / Math.sqrt(x * x + z * z)) * 57.2957795);
    }

    function calcRoll(x,y,z)
    {
         return -(Math.atan(x / Math.sqrt(y * y + z * z)) * 57.2957795);
    }

    SilicaFlickable
    {
        id: flick
        anchors.fill: parent


          PullDownMenu
          {
              MenuItem
              {
                  text: "Tietoja..."
                  onClicked: pageStack.push(Qt.resolvedUrl("TietojaPage.qml"))
              }
          }

        Label
        {
            id: stat
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Taso " + level + " - Pisteet " + score
        }

        Image
        {
            id: pingu
            source: "../pics/eketux.png"
            smooth: true
            property real centerX: page.width / 2
            property real centerY: page.height / 2
            property real pinguCenter: pingu.width / 2
            x: centerX - pinguCenter
            y: centerY - pinguCenter

            Behavior on y {
                SmoothedAnimation {
                    easing.type: Easing.Linear
                    duration: 100
                }
            }

            Behavior on x {
                SmoothedAnimation {
                    easing.type: Easing.Linear
                    duration: 100
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.Linear
                }
            }
        }

        Label
        {
            id: scoretus
            text: "huu"
            z: 2 // piirrä päällimmäiseksi
            anchors.centerIn: parent
            visible: false
            Behavior on font.pixelSize {
                NumberAnimation
                {
                    id:scoretusani
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

        }

        Image
        {
            id: kala
            z: 1 // piirrä kala pingun päälle
            y: randomNumber(30, page.height - pingu.height)
            x: randomNumber(pingu.width, page.width - pingu.width)
            source: "../pics/sc-fish0.png"
            Behavior on y {
                SmoothedAnimation {
                    id: kalaYa
                    duration: 1000
                    velocity: 1
                    easing.type: Easing.OutInQuad
                }
            }
            Behavior on x {
                SmoothedAnimation {
                    id: kalaXa
                    duration: 1000
                    velocity: 1
                    easing.type: Easing.OutInQuad
                }
            }

        }
    }

    Timer
    {
        // piilottaa kalasta saadut pisteet
        id: timerScoretus
        interval: scoretusani.duration; running: false;
        onTriggered:
        {
            scoretus.visible = false
            scoretusani.duration = 1
            scoretus.font.pixelSize = 1
        }
    }


    Timer
    {
        // vaihtaa kalan paikkaa 1 sek välein
        // pyörii aina kun sivu aktiivinen
        id: timerKala
        interval: (level > 5) ? 500 : 1000
        running: applicationActive  && page.status === PageStatus.Active
        repeat: true

        onTriggered:
        {
            // Kala liikkuu koko ajan
            // tämä pitää palauttaa koska nollattiin kun kala syötiin
            kalaXa.duration = kalaYa.duration = timerKala.interval

            // tee vain pieni liike kerrallaan, suurenna liikettä vaikeustason kasvaessa
            var siirtymä = 100+(level*100)
            var siirtymäX = randomNumber(0,siirtymä)-(siirtymä/2)
            var siirtymäY = randomNumber(0,siirtymä)-(siirtymä/2)
            var nx = kala.x + siirtymäX
            var ny = kala.y + siirtymäY

            // Siirry suoraan, ei mutkitella -- velocity = units/second
            kalaXa.velocity = (level > 5) ? (2*Math.abs(siirtymäX)) : Math.abs(siirtymäX)
            kalaYa.velocity = (level > 5) ? (2*Math.abs(siirtymäY)) : Math.abs(siirtymäY)

            if (nx < pingu.width/2)
                nx = pingu.width/2
            if (nx > (page.width - pingu.width/2))
                nx = (page.width - pingu.width/2)
            if (ny < 30)
                ny = 30
            if (ny > (page.height - pingu.height))
                ny = (page.height - pingu.height)

            kala.mirror = (nx > kala.x)

            kala.x = nx
            kala.y = ny
        }
    }

    Timer
    {
        // Palauttaa pingun oikean kokoiseksi kalan syönnin jälkeen
        id: timerPalauta
        interval: 100; running: false;
        onTriggered:
        {
            pingu.scale = 1
        }
    }

    Timer
    {
        // Siika tulee 30 sekunnin välein
        id: timerSiika
        interval: 30000; running: applicationActive  && page.status === PageStatus.Active;
        onTriggered:
        {
        }
    }



}

/****************************************************************************
**
** Fishs picture courtesy of
** http://graphicssoft.about.com/od/freedownloads/l/blfreepng07.htm
**
****************************************************************************/

/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtSensors module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
