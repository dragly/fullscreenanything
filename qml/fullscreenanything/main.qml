import QtQuick 2.0
import QtQuick.Controls 1.1
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
        fullScreen: displaySettings.fullScreen
        topMost: displaySettings.topMost
        leftMost: displaySettings.leftMost
        rightMost: displaySettings.rightMost
        bottomMost: displaySettings.bottomMost
    }

    DisplaySettings {
        id: displaySettings
        screenInfo: screenInfo
        anchors.fill: parent
        focus: true
    }
}
