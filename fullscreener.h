#ifndef FULLSCREENER_H
#define FULLSCREENER_H

#include <QObject>

#include <QDebug>
#include <QQuickItem>
#include <QQuickWindow>

#ifdef Q_OS_LINUX
#include <X11/extensions/Xinerama.h>
#include <X11/Xlib.h>
#include <X11/X.h>
#endif

class FullScreener : public QObject
{
    Q_OBJECT
public:
    explicit FullScreener(QObject *parent = 0);

    Q_INVOKABLE void fullScreenWindowUnderCursor();
    void sendToChildren(Display *display, Window win);
signals:

public slots:

};

#endif // FULLSCREENER_H
