{application, test,
[{description, "Test server"},
{vsn, "1.0"},
{modules, [test_app, test_supervisor, test_server, test_utils, test_settings]},
{registered,[test_server]},
{applications, [kernel,stdlib, yaws]},
{mod, {test_app,[]}},
{start_phases, []}
]}.