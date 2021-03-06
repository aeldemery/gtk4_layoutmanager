public class Gtk4Demo.ShufflingRectangles : Gtk.Widget {
    /* whether we go 0 -> 1 or 1 -> 0 */
    bool backward;
    /* time the transition started */
    int64 start_time;
    /* our tick cb */
    uint tick_id;
    /* The widget is controlling the transition by calling
     * set_position() in a tick callback.
     *
     * We take half a second to go from one layout to the other.
     */
    const double DURAION = 0.5 * GLib.TimeSpan.SECOND;

    const int column_width = 5;

    const string[] color = {
        "red", "orange", "yellow", "green",
        "blue", "grey", "magenta", "lime",
        "yellow", "firebrick", "aqua", "purple",
        "tomato", "pink", "thistle", "maroon",
        "black", "white", "brown", "blueviolet",
        "chartreuse", "CadetBlue", "Coral", "DarkCyan", "GreenYellow"
    };

    static construct {
        /* here is where we use our custom layout manager */
        // set_layout_manager_type (typeof (ShufflingLayoutManager));
    }

    public ShufflingRectangles () {
        var layout = new ShufflingLayoutManager ();
        this.set_layout_manager (layout);

        layout.set_desired_column_width (column_width);
        var margin = color.length / column_width;

        for (int i = 0; i < color.length; i++) {
            var child = new ColorRect (color[i]);
            child.margin_start = margin;
            child.margin_end = margin;
            child.margin_top = margin;
            child.margin_bottom = margin;
            this.add_child (child);
        }

        var gesture = new Gtk.GestureClick ();
        gesture.pressed.connect ((n_press, x, y) => {
            if (tick_id != 0) return;

            start_time = GLib.get_monotonic_time ();
            tick_id = this.add_tick_callback (transition);
        });

        this.add_controller (gesture);
    }

    public void add_child (Gtk.Widget widget) {
        var layout = (ShufflingLayoutManager) layout_manager;
        layout.add_element ();
        widget.set_parent (this);
    }

    protected override void dispose () {
        var child = this.get_first_child ();
        while (child != null) {
            child.unparent ();
            child = this.get_first_child ();
        }

        base.dispose ();
    }

    bool transition (Gtk.Widget widget, Gdk.FrameClock frame_clock) {
        var layout = (ShufflingLayoutManager) layout_manager;
        var now = get_monotonic_time ();
        this.queue_allocate ();

        if (backward) {
            layout.set_position (1.0 - (now - start_time) / DURAION);
        } else {
            layout.set_position ((now - start_time) / DURAION);
        }

        if (now - start_time >= DURAION) {
            backward = !backward;
            layout.set_position (backward ? 1.0 : 0.0);
            /* keep things interesting by shuffling the positions */
            if (!backward) {
                layout.shuffle ();
            }
            tick_id = 0;
            return Source.REMOVE;
        }
        return Source.CONTINUE;
    }
}