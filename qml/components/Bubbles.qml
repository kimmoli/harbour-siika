/*
    Bubbles - a bubbling action background for siika

    Copyright (c) 2013 Kimmo Lindholm, (kimmoli) kimmo.lindholm@gmail.com

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

*/


import QtQuick 2.0
import Sailfish.Silica 1.0


Item
{
    id: bubbles

    property int numberOfBubbles: 25
    property bool makeBubbles: false

    signal animationComplete(int  n)

    function randomNumber(from, to)
    {
        return Math.floor(Math.random() * (to - from + 1) + from);
    }

    function restartBubble(thisBubble)
    {
        thisBubble.xCord = randomNumber( 45/2 , bubbles.width - 45) - (45 / 2)
        thisBubble.bubbleSize = randomNumber( 3, 10) / 10
        thisBubble.speed = randomNumber(500, 2000)
        thisBubble.startBubbling()
    }

    onAnimationComplete:
    {
        var thisBubble = lotsOfBubbles.itemAt(n)

        if ((randomNumber(0, 1) === 1) && makeBubbles)
            restartBubble(thisBubble)
        else
            thisBubble.bubbling = false
    }

    Timer
    {
        id: bubbleTimer
        running: makeBubbles
        interval: 50

        onTriggered:
        {
            var thisBubble = lotsOfBubbles.itemAt( randomNumber(0, numberOfBubbles - 1) )

            if (!thisBubble.bubbling)
            {
                thisBubble.bubbling = true
                restartBubble(thisBubble)
                bubbleTimer.interval = randomNumber(50, 300)
            }
            bubbleTimer.start()
        }
    }

    Repeater
    {
        model: numberOfBubbles
        id: lotsOfBubbles

        Item
        {
            id: movingBubble

            property alias xCord: oneBubble.x
            property alias speed: bubbleAnimation.duration
            property alias bubbleSize: oneBubble.scale
            property alias bubbling: oneBubble.visible

            function startBubbling()
            {
                bubbleAnimation.restart()
            }

            Image
            {
                id: oneBubble
                source: "../pics/kupla.png"
                smooth: true
                visible: false
            }

            NumberAnimation
            {
                signal thisAnimationComplete(int n)
                id: bubbleAnimation
                target: oneBubble
                property: "y"
                alwaysRunToEnd: true
                easing.type: Easing.Linear
                from: bubbles.height
                to: 0
                duration: 2000
                running: false
                onStopped: thisAnimationComplete(index)
            }

            Component.onCompleted:
            {
                bubbleAnimation.thisAnimationComplete.connect(animationComplete)
            }
        }
    }
}



