public class Gtk4Demo.ColorRect : Gtk.Widget {
    Gdk.RGBA color;
    public ColorRect (string color) {
        Object (tooltip_text: color);

        Gdk.RGBA c = {};
        c.parse (color);
        this.color = c;
    }

    protected override void measure (Gtk.Orientation orientation,
                                     int for_size,
                                     out int minimum,
                                     out int natural,
                                     out int minimum_baseline,
                                     out int natural_baseline) {
        minimum = natural = 32;
        minimum_baseline = natural_baseline = -1;
    }

    protected override void snapshot (Gtk.Snapshot snapshot) {
        snapshot.append_color (color, {{0,0}, {get_width(), get_height()}});
    }
}
