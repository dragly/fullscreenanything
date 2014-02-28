#include "fullscreener.h"

FullScreener::FullScreener(QObject *parent) :
    QObject(parent)
{
}

void FullScreener::sendToChildren(Display* display, Window win) {
    Window root_win, parent_win;
    unsigned int num_children;
    Window *child_list;
    XEvent xev;

    if (!XQueryTree(display, win, &root_win, &parent_win, &child_list,
                    &num_children)) {
        return;
    }
    for (int i = (int)num_children - 1; i >= 0; i--) {
        Atom wm_state = XInternAtom(display, "_NET_WM_STATE", False);
        Atom fullscreen = XInternAtom(display, "_NET_WM_STATE_FULLSCREEN", False);
        memset(&xev, 0, sizeof(xev));
        xev.type = ClientMessage;
        xev.xclient.window = child_list[i];
        //    xev.xclient.window = dynamic_cast<QQuickItem*>(parent())->window()->winId();
        xev.xclient.message_type = wm_state;
        xev.xclient.format = 32;
        xev.xclient.data.l[0] = 1;
        xev.xclient.data.l[1] = fullscreen;
        xev.xclient.data.l[2] = 0;
        XSendEvent(display, XDefaultRootWindow(display), False,
                   SubstructureNotifyMask, &xev);

        // Fullscreen on certain monitors
        Atom fullmons = XInternAtom(display, "_NET_WM_FULLSCREEN_MONITORS", False);
        XEvent xev2;
        memset(&xev2, 0, sizeof(xev2));
        xev2.type = ClientMessage;
        xev2.xclient.window = child_list[i];
        xev2.xclient.message_type = fullmons;
        xev2.xclient.format = 32;
        xev2.xclient.data.l[0] = 0; /* your topmost monitor number */
        xev2.xclient.data.l[1] = 0; /* bottommost */
        xev2.xclient.data.l[2] = 0; /* leftmost */
        xev2.xclient.data.l[3] = 0; /* rightmost */
        xev2.xclient.data.l[4] = 0; /* source indication */

        XSendEvent (display, DefaultRootWindow(display), False,
                    SubstructureRedirectMask | SubstructureNotifyMask, &xev2);

        // recurse
        sendToChildren(display, child_list[i]);
    }
}

void FullScreener::fullScreenWindowUnderCursor()
{
#ifdef Q_OS_LINUX
    Display* display;
    display = XOpenDisplay(NULL);
    XSynchronize(display, True);

    // Get pointer information

    // Fullscreen
    Window x11w;
    Window x11wc;
    Window dummy;
    int dummyInt;
    uint dummyUInt;
    bool ok = XQueryPointer(display, DefaultRootWindow(display), &x11w, &x11wc, &dummyInt, &dummyInt, &dummyInt, &dummyInt, &dummyUInt);
    sendToChildren(display, x11wc);
    XFlush(display);
#endif
}
