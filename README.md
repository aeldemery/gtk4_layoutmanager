# Vala Gtk4 Layout Manager Demo

## Table of Contents

- [About](#about)
- [Animation](#animation)

## About <a name = "about"></a>

Vala Implementation of Gtk4 Layout Manager demo.

This demo shows custom layout manager could be implemented and a widget using it. The layout manager places the children of the widget in a grid or a circle, or something in between.
The widget is animating the transition between the two layouts. Click to start the transition.

### Prerequisites

This App was compiled with `Vala` master against `gtk4` master.


### Installing

Clone the repository then

```
- meson builddir
- ninja -C builddir
```

## Animation <a name = "animation"></a>

![Animation](https://github.com/aeldemery/gtk4_layoutmanager/blob/master/Peek%201.gif)