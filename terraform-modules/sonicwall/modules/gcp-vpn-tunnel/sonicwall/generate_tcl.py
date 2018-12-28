import os


def get_script_text(script_name):
    # referencing 'sonicwall' is a hack
    full_name = os.getcwd() + "/sonicwall/" + script_name
    f = open(full_name, "r")
    script_text = f.read()
    f.close()
    script_text_with_header_and_footer = "# {}-BEGIN\n{}# {}-END\n".format(
        script_name, script_text, script_name)
    return script_text_with_header_and_footer


def show_config():
    script_fragments = []
    script_fragments.append('puts "Get Partial SonicWall Configuration"')
    script_fragments.append(get_script_text("010_send_with_pause_proc.tcl"))
    script_fragments.append(get_script_text(
        "020_validate_input_show_config.tcl"))
    script_fragments.append(get_script_text("030_init_show_config.tcl"))
    script_fragments.append(get_script_text("040_login.tcl"))
    script_fragments.append(get_script_text("210_show_config.tcl"))
    script_fragments.append(get_script_text("300_cancel.tcl"))
    script_fragments.append(get_script_text("310_logout.tcl"))
    script_fragments.append(get_script_text("320_interact.tcl"))
    script_text = '\n'.join(script_fragments)
    return script_text


def configure():
    script_fragments = []
    script_fragments.append('puts "Configure GPC tunnel on SonicWall"')
    script_fragments.append(get_script_text("010_send_with_pause_proc.tcl"))
    script_fragments.append(get_script_text(
        "020_validate_input_config_unconfig.tcl"))
    script_fragments.append(get_script_text("030_init_config_unconfig.tcl"))
    script_fragments.append(get_script_text("040_login.tcl"))
    script_fragments.append(get_script_text(
        "050_configure_address_objects_and_group.tcl"))
    script_fragments.append(get_script_text("060_configure_fw_rules.tcl"))
    script_fragments.append(get_script_text("070_configure_vpn_policy.tcl"))
    script_fragments.append(get_script_text("080_configure_vpn_interface.tcl"))
    script_fragments.append(get_script_text("090_configure_bgp.tcl"))
    script_fragments.append(get_script_text("300_cancel.tcl"))
    script_fragments.append(get_script_text("310_logout.tcl"))
    script_fragments.append(get_script_text("320_interact.tcl"))
    script_text = '\n'.join(script_fragments)
    return script_text


def unconfigure():
    script_fragments = []
    script_fragments.append('puts "Unconfigure GPC tunnel on SonicWall"')
    script_fragments.append(get_script_text("010_send_with_pause_proc.tcl"))
    script_fragments.append(get_script_text(
        "020_validate_input_config_unconfig.tcl"))
    script_fragments.append(get_script_text("030_init_config_unconfig.tcl"))
    script_fragments.append(get_script_text("040_login.tcl"))
    script_fragments.append(get_script_text(
        "110-unconfigure_bgp.tcl"))
    script_fragments.append(get_script_text(
        "120_unconfigure_vpn_interface.tcl"))
    script_fragments.append(get_script_text("130_unconfigure_vpn_policy.tcl"))
    script_fragments.append(get_script_text("140_unconfigure_fw_rules.tcl"))
    script_fragments.append(get_script_text(
        "150_unconfigure_address_objects_and_group.tcl"))
    script_fragments.append(get_script_text("310_logout.tcl"))
    script_fragments.append(get_script_text("320_interact.tcl"))
    script_text = '\n'.join(script_fragments)
    return script_text
