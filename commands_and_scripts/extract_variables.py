import re

# Read the search results from a file
with open(r'documents\search_for_variables_results.txt', 'r') as file:
    lines = file.readlines()

# Extract variables starting with profile.
variables = set()
pattern = re.compile(r'profile\.\w+\.\w+')

for line in lines:
    matches = pattern.findall(line)
    for match in matches:
        variables.add(match)

# Write unique variables to a new file
with open(r'documents\unique_variables.txt', 'w') as file:
    for variable in sorted(variables):
        file.write(variable + '\n')

print("Unique variables extracted successfully.")
