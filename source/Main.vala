int main (string[] args) {
    var app = new Gtk4Demo.LayoutManagerApp();
    return app.run(args);
}

class Gtk4Demo.LayoutManagerApp : Gtk.Application {
    public LayoutManagerApp () {
        Object (
            application_id: "github.aeldemery.gtk4_layoutmanager",
            flags : GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var win = active_window;
        if (win == null) {
            win = new MainWindow (this);
        }
        win.present();
    }
}