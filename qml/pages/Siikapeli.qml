import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0 as Sensors
import QtMultimedia 5.0 as Media


Page {
    id: page

    property int score: 0
    property int siika: 1
    property int level: 1


    Media.SoundEffect
    {
        id: playSound
        source: "../wavs/nomnom.wav"
        //    Audio allows to use system volume
    }

    Media.SoundEffect
    {
        id: playSiika
        source: "../wavs/kahenkilonsiika.wav"
        // Soundeffect will ALWAYS play with full extra loud volume (even muted)
    }

    Sensors.Accelerometer
    {
        id: accel
        dataRate: 100
        active: applicationActive && page.status === PageStatus.Active


        onReadingChanged:
        {
            var newX = (bubble.x + calcRoll(accel.reading.x, accel.reading.y, accel.reading.z) * .1)
            var newY = (bubble.y - calcPitch(accel.reading.x, accel.reading.y, accel.reading.z) * .1)


            if (newX < 0)
                newX = 0

            if (newX > page.width - bubble.width)
                newX = page.width - bubble.width

            if (newY < 18)
                newY = 18

            if (newY > page.height - bubble.height)
                newY = page.height - bubble.height

                bubble.x = newX
                bubble.y = newY

            stat.text = "Taso " + level + " - Pisteet " + score

            if (((newX + (bubble.width/2)) > (nami.x - 20)) && ((newX + (bubble.width/2)) < (nami.x + 30)) && (newY > (nami.y - 20)) && (newY < (nami.y + 30)))
            {

                if (siika == 10) // siika tuli
                {
                    playSiika.play()
                    level = level + 1
                }
                else        // joku sintti
                {
                    playSound.play()
                }
                bubble.scale = 2
                timerlamppu.start()
                var kala = Math.floor(nami.scale * 10) * siika
                score = score + kala
                if (siika == 10)
                    scoretus.text = "TASO " + level
                else
                    scoretus.text = kala
                scoretusani.duration = 400
                scoretus.visible =  true
                scoretus.font.pixelSize = 250
                timerscoretus.start()

                namiXa.duration = 0
                namiYa.duration = 0

                nami.x = randomNumber(bubble.width, page.width - bubble.width)
                if (nami.y < page.height/2) // ylempi puolikas, seuraava alas
                    nami.y = randomNumber(page.height/2, page.height - bubble.height)
                else
                    nami.y = randomNumber(30, page.height/2)

                if (timersiika.running)
                {
                    nami.source = "../pics/sc-fish" + randomNumber(0,5) +".png"
                    nami.scale = 1 + (randomNumber(0,10)/10)
                    siika = 1
                }
                else // kahen kilon siika seuraavaksi
                {
                    nami.source = "../pics/sc-fish6.png"
                    nami.scale = 1
                    siika = 10
                    timersiika.restart()
                }

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
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Taso " + level + " - Pisteet " + score
        }

        Image
        {
            id: bubble
            source: "../pics/eketux.png"
            smooth: true
            property real centerX: page.width / 2
            property real centerY: page.height / 2
            property real bubbleCenter: bubble.width / 2
            x: centerX - bubbleCenter
            y: centerY - bubbleCenter

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
            anchors.centerIn: parent
            visible: false
            Behavior on font.pixelSize {
                NumberAnimation
                {
                    id:scoretusani
                    duration: 300
                    easing.type: Easing.Linear
                }
            }

        }

        Image
        {
            id: nami
            z: 1 // draw on top of pingu
            y: randomNumber(30, page.height - bubble.height)
            x: randomNumber(bubble.width, page.width - bubble.width)
            source: "../pics/sc-fish0.png"
            Behavior on y {
                NumberAnimation {
                    id: namiYa
                    duration: 1000
                    easing.type: Easing.Linear
                }
            }
            Behavior on x {
                NumberAnimation {
                    id: namiXa
                    duration: 1000
                    easing.type: Easing.Linear
                }
            }

        }
    }

    Timer
    {
        id: timerscoretus
        interval: scoretusani.duration; running: false;
        onTriggered:
        {
            scoretus.visible = false
            scoretusani.duration = 1
            scoretus.font.pixelSize = 1
        }
    } // Timer


    Timer
    {
        // vaihtaa kalan paikkaa 1 sek välein
        id: timerkala
        interval: 1000; running: applicationActive  && page.status === PageStatus.Active; repeat: true
        onTriggered:
        {
            if (level > 5)
            {
                namiXa.duration = 500
                namiYa.duration = 500
            }
            else
            {
                namiXa.duration = 1000
                namiYa.duration = 1000
            }
            // tee vain pieni liike kerrallaan, suurenna liikettä vaikeustason kasvaessa
            var siirtymä = 100+(level*100)
            var nx = nami.x + (randomNumber(0,siirtymä)-(siirtymä/2))
            var ny = nami.y + (randomNumber(0,siirtymä)-(siirtymä/2))

            if (nx < bubble.width)
                nx = bubble.width
            if (nx > (page.width - bubble.width))
                nx = (page.width - bubble.width)
            if (ny < 30)
                ny = 30
            if (ny > (page.height - bubble.height))
                ny = (page.height - bubble.height)

            nami.mirror = (nx > nami.x)

            nami.x = nx
            nami.y = ny
        }
    } // Timer

    Timer
    {
        id: timerlamppu
        interval: 100; running: false;
        onTriggered:
        {
            bubble.scale = 1
        }
    } // Timer

    Timer
    {
        id: timersiika
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
