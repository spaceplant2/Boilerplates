# Synopsis
I've been working on getting Prometheus metrics for my environment pushed into Grafana and displayed properly. One of the first issuses I ran into, and the one issue that consistently and repeatedly tosses up road blocks is how to get data for an endpoint once it is in the Grafana server. This is complicated by the ammount of customization that can be done with exporters.

To deal with this, I created a simple script to reach out to the exporter on a running endpoint and parse it into a more readable layout. The execution is fairly simple- copy script, aim it at the endpoint's exporter, then open the resulting file in a markdown viewer.

Hopefully this will help you in your own journey, or at least inspire you to create something that is much more useful to you.

# Installation

download the python script:
`curl -O exporter-data-parser.py`

install dependencies `requests`:
*depending on how you have installed python and what OS you are using*

- `pip install requests`
- `apt install python3-requests`
- `yum install python-requests`

run the python script:
*depending on how your environment is set up*

`python exporter-data-parser.py`
`python3 exporter-data-parser.py`

