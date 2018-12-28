from .gcp_subnets import GcpSubnets


def mock_data_valid_non_empty_primary_and_secondary_subnets():
    return GcpSubnets("k8s-nodes-1,k8s-nodes-2",
                      "10.24.101.0/24,10.24.102.0/24",
                      "k8s-pods-1,k8s-pods-2",
                      "10.36.0.0/16,10.37.0.0/16",
                      "k8s-svcs-1,k8s-svcs-2",
                      "10.221.1.0/24,10.221.2.0/24")


def mock_data_invalid_empty_primary_and_secondary_subnets():
    return GcpSubnets("", "", "", "", "", "")


def mock_data_valid_two_primary_subnets():
    return GcpSubnets("k8s-nodes-1,k8s-nodes-2",
                      "10.24.101.0/24,10.24.102.0/24",
                      "", "", "", "")


def mock_data_valid_one_primary_subnet():
    return GcpSubnets("k8s-nodes-1",
                      "10.24.101.0/24",
                      "", "", "", "")


def mock_data_valid_spaces_inside_subnet_name_and_cidr_lists():
    return GcpSubnets("k8s-nodes-1, k8s-nodes-2",
                      " 10.24.101.0/24,10.24.102.0/24 ",
                      "", "", "", "")


def mock_data_invalid_more_primary_subnet_cidrs_than_names():
    return GcpSubnets("k8s-nodes-1",
                      "10.24.101.0/24,10.24.102.0/24",
                      "", "", "", "")


def mock_data_invalid_more_primary_subnet_names_than_cidrs():
    return GcpSubnets("k8s-nodes-1,k8s-nodes-2",
                      "10.24.102.0/24",
                      "", "", "", "")


def mock_data_invalid_only_secondary_2_subnets():
    return GcpSubnets("",
                      "",
                      "k8s-pods-1,k8s-pods-2",
                      "10.36.0.0/16,10.37.0.0/16",
                      "",
                      "")


def mock_data_invalid_only_secondary_2_subnets():
    return GcpSubnets("",
                      "",
                      "",
                      "",
                      "k8s-svcs-1,k8s-svcs-2",
                      "10.221.1.0/24,10.221.2.0/24")


def mock_data_invalid_only_secondary_1_2_subnets():
    return GcpSubnets("",
                      "",
                      "k8s-pods-1,k8s-pods-2",
                      "10.36.0.0/16,10.37.0.0/16",
                      "k8s-svcs-1,k8s-svcs-2",
                      "10.221.1.0/24,10.221.2.0/24")


mock_data_subnets = [
    (mock_data_valid_non_empty_primary_and_secondary_subnets(), True),
    (mock_data_invalid_empty_primary_and_secondary_subnets(), False),
    (mock_data_valid_two_primary_subnets(), True),
    (mock_data_valid_one_primary_subnet(), True),
    (mock_data_valid_spaces_inside_subnet_name_and_cidr_lists(), True),
    (mock_data_invalid_more_primary_subnet_cidrs_than_names(), False),
    (mock_data_invalid_more_primary_subnet_names_than_cidrs(), False),
    (mock_data_invalid_only_secondary_2_subnets(), False),
    (mock_data_invalid_only_secondary_2_subnets(), False),
    (mock_data_invalid_only_secondary_1_2_subnets(), False)
]
