public class Gtk4Demo.ShufflingLayoutManager : Gtk.LayoutManager {
    double position;
    Gee.ArrayList<uint> child_pos;

    static uint n_children = 0;
    int n_grid_columns = 4;

    public ShufflingLayoutManager () {
        child_pos = new Gee.ArrayList<uint>();
    }

    public void add_element () {
        ++n_children;
        child_pos.add (n_children);
    }

    public void set_desired_column_width (int n_elements) {
        this.n_grid_columns = n_elements;
    }

    public void set_position (double position) {
        this.position = position;
    }

    /* Shuffle the circle positions of the children.
     * Should be called when we are in the grid layout.
     */
    public void shuffle () {
        int i, j; uint tmp;

        for (i = 0; i < n_children; i++) {
            j = Random.int_range (0, i + 1);
            tmp = (uint) child_pos[i];
            child_pos[i] = child_pos[j];
            child_pos[j] = tmp;
        }
    }

    protected override void measure (Gtk.Widget widget,
                                     Gtk.Orientation orientation,
                                     int for_size,
                                     out int minimum,
                                     out int natural,
                                     out int minimum_baseline,
                                     out int natural_baseline) {
        Gtk.Widget child;
        int minimum_size = 0;
        int natural_size = 0;

        for (child = widget.get_first_child ();
             child != null;
             child = child.get_next_sibling ()) {

            if (!child.should_layout ()) continue;

            int child_min = 0;
            int child_nat = 0;
            child.measure (orientation, -1, out child_min, out child_nat, null, null);

            minimum_size = int.max (minimum_size, child_min);
            natural_size = int.max (natural_size, child_nat);
        }

        minimum = (int) (n_children * minimum_size / Math.PI + minimum_size);
        natural = (int) (n_children * natural_size / Math.PI + natural_size);
        minimum_baseline = -1;
        natural_baseline = -1;
    }

    protected override void allocate (Gtk.Widget widget, int width, int height, int baseline) {
        Gtk.Widget child;
        int i;
        int child_width = 0;
        int child_height = 0;
        int x0;
        int y0;
        double r;
        double t;

        t = position;

        for (child = widget.get_first_child ();
             child != null;
             child = child.get_next_sibling ()) {

            if (!child.should_layout ()) continue;

            Gtk.Requisition child_req;
            child.get_preferred_size (out child_req, null);

            child_width = int.max (child_width, child_req.width);
            child_height = int.max (child_height, child_req.height);
        }
        /* the center of our layout */
        x0 = width / 2;
        y0 = height / 2;

        /* the radius for our circle of children */
        r = (n_children / 2) * child_width / Math.PI;

        for (child = widget.get_first_child (), i = 0;
             child != null;
             child = child.get_next_sibling (), i++) {

            if (!child.should_layout ()) continue;

            double a = child_pos[i] * (Math.PI / (n_children / 2));
            int gx, gy;
            int cx, cy;
            int x, y;

            Gtk.Requisition child_req;
            child.get_preferred_size (out child_req, null);

            /* The grid position of child. */
            gx = x0 + (i % n_grid_columns - 2) * child_width;
            gy = y0 + (i / n_grid_columns - 2) * child_height;

            /* The circle position of child. Note that we
             * are adjusting the position by half the child size
             * to place the center of child on a centered circle.
             * This assumes that the children don't use align flags
             * or uneven margins that would shift the center.
             */
            cx = (int) (x0 + Math.sin (a) * r - child_req.width / 2);
            cy = (int) (y0 + Math.cos (a) * r - child_req.height / 2);

            /* we interpolate between the two layouts according to
             * the position value that has been set on the layout.
             */
            x = (int) (t * cx + (1 - t) * gx);
            y = (int) (t * cy + (1 - t) * gy);

            child.size_allocate_emit ({ x, y, child_width, child_height }, -1);
        }
    }

    protected override Gtk.SizeRequestMode get_request_mode (Gtk.Widget widget) {
        return Gtk.SizeRequestMode.CONSTANT_SIZE;
    }
}