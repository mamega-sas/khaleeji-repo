import json
import requests
import urllib3
import csv

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

API_BASE_URL = "https://sfdnp.khaleeji.bank/listData/lists" 
API_KEY = "eyJqa3UiOiJodHRwczovL2xvY2FsaG9zdC9TQVNMb2dvbi90b2tlbl9rZXlzIiwia2lkIjoibGVnYWN5LXRva2VuLWtleSIsInR5cCI6IkpXVCIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiI2ZTVjZjlhZC00ODMyLTQ2MmUtYWY1Yy1lMmQ1NTg1OTAzMGIiLCJ1c2VyX25hbWUiOiJmcmF1ZHN2YyIsIm9yaWdpbiI6ImxkYXAiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0L1NBU0xvZ29uL29hdXRoL3Rva2VuIiwiYXV0aG9yaXRpZXMiOlsibWFuYWdlcl9pbmRpdmlkdWFsX2dyb3VwIiwiU0FTRGV0ZWN0aW9uUm9sZXMiLCJoaWdoX2luZGl2aWR1YWxfZ3JvdXAiLCJtYW5hZ2VyX2NvcnBvcmF0ZV9ncm91cCIsIkFwcGxpY2F0aW9uQWRtaW5pc3RyYXRvcnMiLCJTQVNUcmlhZ2VVc2VycyIsIlNEQVNyUnVsZXNFZGl0b3IiLCJsb3dfY29ycG9yYXRlX2dyb3VwIiwiRGF0YUFnZW50QWRtaW5pc3RyYXRvcnMiLCJGcmF1ZF9EZWNpc2lvbmluZ19BZG1pbmlzdHJhdG9yIiwiRERQVlVHLTM0QkQ5OERDQUU2OUFFQTEiLCJETVNBZG1pbiIsIlNBU0RldGVjdGlvbkFkdmFuY2VkTGlzdHNBY2Nlc3MiLCJHbG9zc2FyeS5HbG9zc2FyeUFkbWluaXN0cmF0b3JzIiwiRERQVlVHLTQ3RUE1Q0Q4MjA2N0MzNEUiLCJsb3dfaW5kaXZpZHVhbF9ncm91cCIsIkRNU1ZpZXdlciIsIkZyYXVkX0RlY2lzaW9uaW5nX1JvbGVzIiwiaGlnaF9jb3Jwb3JhdGVfZ3JvdXAiLCJTREFTeXN0ZW1BZG1pbiIsIkREUFZVRy02ODcyN0VDRUE1QkU1NkY0Il0sImNsaWVudF9pZCI6ImNsaWVudC5jbGkiLCJhdWQiOlsib3BlbmlkIiwiY2xpZW50LmNsaSJdLCJleHRfaWQiOiJjbj1GcmF1ZCBTVkMsb3U9QU1MLG91PVNNR1IsZGM9S0hDQixkYz1DT00iLCJ6aWQiOiJ1YWEiLCJncmFudF90eXBlIjoicGFzc3dvcmQiLCJ1c2VyX2lkIjoiNmU1Y2Y5YWQtNDgzMi00NjJlLWFmNWMtZTJkNTU4NTkwMzBiIiwiYXpwIjoiY2xpZW50LmNsaSIsInNjb3BlIjpbIm9wZW5pZCJdLCJhdXRoX3RpbWUiOjE3NDg5NDU0NzEsImV4cCI6MTgxMjAxNTQ3MSwiaWF0IjoxNzQ4OTQ1NDcxLCJqdGkiOiI1N2Y3MTNlYWIzZDQ0MjMzOTk3YjgyMzdjN2Y5ZThlYiIsImVtYWlsIjoiZnJhdWRzdmNAdXNlci5mcm9tLmxkYXAuY2YiLCJyZXZfc2lnIjoiNTNmN2RkYyIsImNpZCI6ImNsaWVudC5jbGkifQ.Hky9ImP4MX_Q5aYtpKWotTZPRwXXCrBBk5LJSK4-y5rE_s6jxIdGCr5-d4iukWz4xbep5n9NdonKVzQZxzNAaZC9QYVHteWXhwwBdYuYitzkaz1tm5rP7SjQAcFNkMs2430D6YnPPltWjIbgdfIDnaYYPAp2KRqbKVKQSxzTZIj-jzymnY4_Bd0kqT5s8spkPaP8LjPDrnrXB-32HXlnhifQRusyAKFoXkpF_hq8A-bSIusCEzhuu7eLN8pg9vCFplmmv-kt1b8A1V1zqZ7xLTKQ8Nk0y11t2KaWk3VOZJLRDpqUyIb_Ik8Yhq9nNoX3mQFax7VU4wET7u4eKB3H5Q"  # <-- Replace this

PARAMETERS = {
    "limit": 1000
}

HEADERS = {
    "Authorization": f"Bearer {API_KEY}", 
    "Accept": "application/json, application/vnd.sas.collection+json, application/vnd.sas.error+json",
    "Content-Type": "application/json"
}

response = requests.get(API_BASE_URL, headers=HEADERS, verify=False, params=PARAMETERS)

if response.status_code == 200:
    json_data  = response.json()
    lists = json_data.get("items", [])
    with open("commands_and_scripts/clists.csv", mode="w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["ID", "Name"])  # header row
        for lst in lists:
            list_id = lst.get("id", "N/A")
            list_name = lst.get("name", "N/A")
            writer.writerow([list_id, list_name])
    print("Lists have been successfully written to clists.csv")

else:
    print(f"Failed to retrieve data. Status code: {response.status_code}, Response: {response.content}")