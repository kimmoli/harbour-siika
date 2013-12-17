/****************************************************************************
** (C) Kimmo Lindholm 2013
**
**
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
****************************************************************************/

import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    Label
    {

        y: 100
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 50
        font.bold: true
        text: "Siika"
    }
    Label
    {
        y: 160
        anchors.horizontalCenter: parent.horizontalCenter
        text: "made by kimmoli 2013"
    }
    Label
    {
        y: 210
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Lähdekoodi saatavilla"
    }
    Text
    {
        y: 250
        anchors.horizontalCenter: parent.horizontalCenter
        id: link_Text
        text: '<html><a href="https://github.com/kimmoli/harbour-siika">github.com/kimmoli/harbour-siika</a></html>'
        onLinkActivated: Qt.openUrlExternally(link)
    }
    Image
    {
         source: "../pics/sc-fish6.png"
         anchors.centerIn: parent
         Image
         {
              source: "../pics/eketux.png"
              anchors.top: parent.bottom
              anchors.topMargin: 15
              anchors.horizontalCenter: parent.horizontalCenter
              Row
              {
                  anchors.top: parent.bottom
                  anchors.topMargin: 35
                  anchors.horizontalCenter: parent.horizontalCenter
                  spacing: 5
                  Repeater
                  {
                      model: 6
                      Image
                      {
                          source: "../pics/sc-fish" + index +".png"
                      }
                  }
              }

         }
    }



}
