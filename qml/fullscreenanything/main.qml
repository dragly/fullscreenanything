import QtQuick 2.0
import QtQuick.Controls 1.1
import FullScreener 1.0
import ScreenInfo 1.0

Rectangle {
    width: 1280
    height: 720
    focus: true

    ScreenInfo {
        id: screenInfo
        Component.onCompleted: {
            displaySettings.layoutScreens()
        }
        topMost: displaySettings.topMost
        leftMost: displaySettings.leftMost
        rightMost: displaySettings.rightMost
        bottomMost: displaySettings.bottomMost
    }

    FullScreener {
        id: fullScreener
    }

    DisplaySettings {
        id: displaySettings
        screenInfo: screenInfo
        anchors.fill: parent
        focus: true
    }
}
