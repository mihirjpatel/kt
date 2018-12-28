"""Test GcpSubnets"""
import pytest
from .gcp_subnets import GcpSubnets
from .mock_data import *


def test_subnet_object_initialization_1():
    """GcpSubnets with non-empty subnets should initialize correctly"""
    subnets = mock_data_valid_non_empty_primary_and_secondary_subnets()

    assert len(subnets.primary_subnet_names_list) == 2
    assert subnets.primary_subnet_names_list == ["k8s-nodes-1", "k8s-nodes-2"]

    assert len(subnets.primary_subnet_cidrs_list) == 2
    assert subnets.primary_subnet_cidrs_list == [
        "10.24.101.0/24", "10.24.102.0/24"]

    assert len(subnets.secondary_subnet_names_1_list) == 2
    assert subnets.secondary_subnet_names_1_list == [
        "k8s-pods-1", "k8s-pods-2"]

    assert len(subnets.secondary_subnet_cidrs_1_list) == 2
    assert subnets.secondary_subnet_cidrs_1_list == [
        "10.36.0.0/16", "10.37.0.0/16"]

    assert len(subnets.secondary_subnet_names_2_list) == 2
    assert subnets.secondary_subnet_names_2_list == [
        "k8s-svcs-1", "k8s-svcs-2"]

    assert len(subnets.secondary_subnet_cidrs_2_list) == 2
    assert subnets.secondary_subnet_cidrs_2_list == [
        "10.221.1.0/24", "10.221.2.0/24"]


def test_subnet_object_initialization_2():
    """GcpSubnets with empty subnets should initialize correctly"""
    subnets = mock_data_invalid_empty_primary_and_secondary_subnets()

    assert len(subnets.primary_subnet_names_list) == 0
    assert subnets.primary_subnet_names_list == []

    assert len(subnets.primary_subnet_cidrs_list) == 0
    assert subnets.primary_subnet_cidrs_list == []

    assert len(subnets.secondary_subnet_names_1_list) == 0
    assert subnets.secondary_subnet_names_1_list == []

    assert len(subnets.secondary_subnet_cidrs_1_list) == 0
    assert subnets.secondary_subnet_cidrs_1_list == []

    assert len(subnets.secondary_subnet_names_2_list) == 0
    assert subnets.secondary_subnet_names_2_list == []

    assert len(subnets.secondary_subnet_cidrs_2_list) == 0
    assert subnets.secondary_subnet_cidrs_2_list == []


def test_subnet_object_initialization_3():
    """GcpSubnets with spaces in comma-separated lists of names and CIDRs should initialize correctly"""
    subnets = mock_data_valid_spaces_inside_subnet_name_and_cidr_lists()

    assert len(subnets.primary_subnet_names_list) == 2
    assert subnets.primary_subnet_names_list == ["k8s-nodes-1", "k8s-nodes-2"]

    assert len(subnets.primary_subnet_cidrs_list) == 2
    assert subnets.primary_subnet_cidrs_list == [
        "10.24.101.0/24", "10.24.102.0/24"]


def test_subnet_object_initialization_4():
    """GcpSubnets with one primary subnet should initialize correctly"""
    subnets = mock_data_valid_one_primary_subnet()

    assert len(subnets.primary_subnet_names_list) == 1
    assert subnets.primary_subnet_names_list == ["k8s-nodes-1"]

    assert len(subnets.primary_subnet_cidrs_list) == 1
    assert subnets.primary_subnet_cidrs_list == [
        "10.24.101.0/24"]


@pytest.mark.parametrize("config, is_valid", mock_data_subnets)
def test_if_subnet_config_is_valid(config, is_valid):
    assert config.are_subnet_parameters_ok() == is_valid
