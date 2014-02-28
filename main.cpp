#include <QtQuick>
#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#include "screeninfo.h"
#include "screeninfoscreen.h"
#include "fullscreener.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<FullScreener>("FullScreener", 1, 0, "FullScreener");
    qmlRegisterType<ScreenInfo>("ScreenInfo", 1, 0, "ScreenInfo");
    qmlRegisterType<ScreenInfoScreen>("ScreenInfo", 1, 0, "ScreenInfoScreen");

    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/fullscreenanything/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
