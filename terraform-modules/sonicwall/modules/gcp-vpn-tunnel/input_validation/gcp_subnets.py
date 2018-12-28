class GcpSubnets():
    def __init__(self,
                 primary_subnet_names, primary_subnet_cidrs,
                 secondary_subnet_names_1, secondary_subnet_cidrs_1,
                 secondary_subnet_names_2, secondary_subnet_cidrs_2):

        self.primary_subnet_names_list = self.to_list(primary_subnet_names)
        self.primary_subnet_cidrs_list = self.to_list(primary_subnet_cidrs)

        self.secondary_subnet_names_1_list = self.to_list(
            secondary_subnet_names_1)
        self.secondary_subnet_cidrs_1_list = self.to_list(
            secondary_subnet_cidrs_1)

        self.secondary_subnet_names_2_list = self.to_list(
            secondary_subnet_names_2)
        self.secondary_subnet_cidrs_2_list = self.to_list(
            secondary_subnet_cidrs_2)

    def to_list(self, csv_string):
        if len(csv_string) == 0:
            return []
        else:
            lst = csv_string.split(",")
            for cnt, val in enumerate(lst):
                # remove leading and trailing space from each list element
                lst[cnt] = val.strip()
            return lst

    def do_numbers_of_names_and_cidrs_for_all_subnets_match(self):
        result = (
            len(self.primary_subnet_names_list) == len(self.primary_subnet_cidrs_list) and
            len(self.secondary_subnet_names_1_list) == len(self.secondary_subnet_cidrs_1_list) and
            len(self.secondary_subnet_names_2_list) == len(self.secondary_subnet_cidrs_2_list))
        return result

    def do_numbers_of_cidrs_for_all_subnets_match(self):
        result = (
            len(self.primary_subnet_cidrs_list) == len(self.secondary_subnet_cidrs_1_list) and
            len(self.secondary_subnet_cidrs_1_list) == len(self.secondary_subnet_cidrs_2_list))
        return result

    def are_subnet_parameters_ok(self):
        # Two main cases are possible:
        # - primary range is specified but not the secondary ones, any non-zero number of primary subnets is OK
        # - if both primary and secondary ranges are passed, the number of subnets everywhere should be the same
        result = False
        if (self.do_numbers_of_names_and_cidrs_for_all_subnets_match() and
            len(self.primary_subnet_cidrs_list) > 0 and
            (
                self.do_numbers_of_cidrs_for_all_subnets_match() or
                (self.secondary_subnet_names_1_list == []
                    and self.secondary_subnet_names_2_list == [])
        )
        ):
            result = True
        return result
