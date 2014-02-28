#ifndef SCREENINFO_H
#define SCREENINFO_H

#include <QObject>
#include <QQmlListProperty>
#include <QGuiApplication>
#include <QScreen>
#include <QDebug>
#include <QQuickItem>
#include <QQuickWindow>

typedef struct _XDisplay Display;
typedef unsigned long XID;
typedef XID Window;

class ScreenInfoScreen;

class ScreenInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<ScreenInfoScreen> screens READ screens NOTIFY screensChanged)
    Q_PROPERTY(bool fullScreen READ fullScreen WRITE setFullScreen NOTIFY fullScreenChanged)
    Q_PROPERTY(int topMost READ topMost WRITE setTopMost NOTIFY topMostChanged)
    Q_PROPERTY(int bottomMost READ bottomMost WRITE setBottomMost NOTIFY bottomMostChanged)
    Q_PROPERTY(int leftMost READ leftMost WRITE setLeftMost NOTIFY leftMostChanged)
    Q_PROPERTY(int rightMost READ rightMost WRITE setRightMost NOTIFY rightMostChanged)
public:
    explicit ScreenInfo(QObject *parent = 0);

    QQmlListProperty<ScreenInfoScreen> screens();
    bool fullScreen() const;

    int topMost() const;
    int bottomMost() const;
    int leftMost() const;
    int rightMost() const;

    Q_INVOKABLE void apply();

    void sendToChildren(Display *display, Window win);
    Q_INVOKABLE void fullScreenWindowUnderCursor();
signals:
    void screensChanged();

    void fullScreenChanged(bool arg);

    void topMostChanged(int arg);
    void bottomMostChanged(int arg);
    void leftMostChanged(int arg);
    void rightMostChanged(int arg);

public slots:

    void setFullScreen(bool arg);

    void setTopMost(int arg);
    void setBottomMost(int arg);
    void setLeftMost(int arg);
    void setRightMost(int arg);

private:
    QList<ScreenInfoScreen*> m_screens;

    bool m_fullScreen;
    int m_topMost;
    int m_bottomMost;
    int m_leftMost;
    int m_rightMost;
};

#endif // SCREENINFO_H
