import json

file_path = r"C:\Users\mazen\OneDrive\Work\Khaleeji\khaleeji_repo\documents\khaleeji_configs\config\alerts-config\enrichment-mappings\enrichment-mappings.json"

# Load the JSON file
with open(file_path, "r") as f:
    data = json.load(f)

# Extract the list of mappings (assuming it's inside body[0])
mappings = data["body"][0]

# Extract all IDs
ids = [item["id"] for item in mappings if "id" in item]

# Print total count and list of IDs
print(f"Total number of enrichment mapping IDs: {len(ids)}")
print("Extracted IDs:")
for mapping_id in ids:
    print(mapping_id)

# Optional: Save to a file
with open("extracted_ids.txt", "w") as out_file:
    for mapping_id in ids:
        out_file.write(mapping_id + "\n")