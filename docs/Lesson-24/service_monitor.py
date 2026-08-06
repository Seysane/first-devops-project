import requests
import yaml

# List of services to check
services = [
    "https://api.github.com",
    "https://google.com",
]

report = {
    "services_status": {},
    "environment_info": {},
}

# Check service availability
for url in services:
    try:
        response = requests.get(url, timeout=5)

        if response.status_code == 200:
            report["services_status"][url] = "🟢 UP"
        else:
            report["services_status"][url] = "🔴 DOWN"

    except requests.RequestException:
        report["services_status"][url] = "🔴 DOWN"

# Download weather information
try:
    response = requests.get(
        "https://wttr.in/Dublin?format=j1",
        timeout=10,
    )

    data = response.json()

    current = data["current_condition"][0]

    report["environment_info"] = {
        "location": "Dublin",
        "temperature_C": current["temp_C"],
        "humidity": current["humidity"],
        "weather": current["weatherDesc"][0]["value"],
    }

except Exception:
    report["environment_info"] = {
        "location": "Dublin",
        "temperature_C": "Unknown",
        "humidity": "Unknown",
        "weather": "Unknown",
    }

# Save report as YAML
with open(
    "daily_report.yaml",
    "w",
    encoding="utf-8",
) as file:
    yaml.dump(
        report,
        file,
        allow_unicode=True,
        sort_keys=False,
    )

print("Report successfully saved to daily_report.yaml")