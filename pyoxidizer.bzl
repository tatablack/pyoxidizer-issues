def make_exe():
    dist = default_python_distribution()

    policy = dist.make_python_packaging_policy()
    policy.resources_location = "in-memory"
    policy.resources_location_fallback = "filesystem-relative:prefix"

    python_config = dist.make_python_interpreter_config()
    python_config.run_module = "src.main"

    exe = dist.to_python_executable(
        name="pyoxidizer_test",
        packaging_policy=policy,
        config=python_config,
    )

    exe.add_python_resources(exe.pip_install(["-r", "requirements.txt"]))

    exe.add_python_resources(exe.read_package_root(
        path="./",
        packages=["src"],
    ))

    return exe

def make_embedded_resources(exe):
    return exe.to_embedded_resources()

def make_install(exe):
    # Create an object that represents our installed application file layout.
    files = FileManifest()

    # Add the generated executable to our install layout in the root directory.
    files.add_python_resource(".", exe)

    return files

# Tell PyOxidizer about the build targets defined above.
register_target("exe", make_exe)
register_target("resources", make_embedded_resources, depends=["exe"], default_build_script=True)
register_target("install", make_install, depends=["exe"], default=True)

# Resolve whatever targets the invoker of this configuration file is requesting
# be resolved.
resolve_targets()
