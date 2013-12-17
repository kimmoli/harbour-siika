import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0 as Sensors
import QtMultimedia 5.0 as Media
//import QtFeedback 5.0 as Feedback


// Fish picture courtesy of http://graphicssoft.about.com/od/freedownloads/l/blfreepng07.htm

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
        // Dont jump
    }

//    Feedback.HapticsEffect
//    {
//        id: rumbleEffect
//        attackIntensity: 0.0
//        attackTime: 250
//        intensity: 1.0
//        duration: 100
//        fadeTime: 250
//        fadeIntensity: 0.0
//    }


    Sensors.Accelerometer
    {
        id: accel
        dataRate: 100
        active: applicationActive


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

                if (siika == 10)
                {
//                    rumbleEffect.start()
                    playSiika.play()
                    level = level + 1
                }
                else        // ei siikaa
                {
//                    rumbleEffect.start()
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

                //info.displayError("Omnomnom " + score)

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


    Label
    {
        id: stat
        anchors.top: page.top
        anchors.horizontalCenter: page.horizontalCenter
        text: "Pisteet 0"
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
        anchors.centerIn: page
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


    Timer
    {
        // vaihtaa kalan paikkaa 1 sek välein
        id: timerkala
        interval: 1000; running: applicationActive; repeat: true
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
        interval: 30000; running: applicationActive;
        onTriggered:
        {
        }
    }



}
