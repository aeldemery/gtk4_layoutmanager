project (
    'github.aeldemery.gtk4_layoutmanager',
    'c', 'vala',
    version: '0.1.0',
)

sources = files (
    'source/Main.vala',
    'source/MainWindow.vala',
    'source/ColorRect.vala',
    'source/ShufflingLayoutManager.vala',
    'source/ShufflingRectangles.vala',
)

sources += import ('gnome').compile_resources (
    'project-resources',
    'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
)

dependencies = [
    dependency ('gobject-2.0'),
    dependency ('glib-2.0'),
    dependency ('gtk4'),
    dependency ('gee-0.8'),
    meson.get_compiler ('c').find_library ('m', required: false),
]

executable (
    meson.project_name(),
    sources: sources,
    dependencies: dependencies,
    install: true,
)