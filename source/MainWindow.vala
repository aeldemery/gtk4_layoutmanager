public class Gtk4Demo.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application app) {
        Object (application: app);

        title = "Layout Manager";
        default_width = 600;
        default_height = 600;

        

        var shuffling_widget = new ShufflingRectangles ();
        this.set_child (shuffling_widget);
    }
}