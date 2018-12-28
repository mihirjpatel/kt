def add_shebang(script_lines):
    script_lines.append('#!/bin/bash')
    script_lines.append('')  # empty line


def add_env_vars(script_lines, config):

    for setting in config:
        line = setting.upper() + "='{}' \\".format(config[setting])
        script_lines.append(line)


def add_call_to_expect(script_lines, script_name):

    script_lines.append("expect -f {}".format(script_name))


def get_sh_script(tcl_script_name, config):
    script_lines = []
    add_shebang(script_lines)
    add_env_vars(script_lines, config)
    add_call_to_expect(script_lines, tcl_script_name)
    return "\n".join(script_lines)
