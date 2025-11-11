#!/usr/bin/env python3
import requests
import sys
from collections import defaultdict

def parse_metrics(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.text
    except requests.exceptions.RequestException as e:
        print(f"Error fetching metrics: {e}")
        sys.exit(1)

def categorize_metrics(metrics_text):
    categories = defaultdict(list)
    current_help = {}
    current_type = {}
    
    lines = metrics_text.split('\n')
    
    for line in lines:
        line = line.strip()
        
        if line.startswith('# HELP'):
            parts = line.split(' ', 3)
            if len(parts) >= 4:
                metric_name = parts[2]
                help_text = parts[3]
                current_help[metric_name] = help_text
                
        elif line.startswith('# TYPE'):
            parts = line.split(' ', 3)
            if len(parts) >= 4:
                metric_name = parts[2]
                metric_type = parts[3]
                current_type[metric_name] = metric_type
                
        elif line and not line.startswith('#'):
            # Extract metric name and labels
            metric_name = line.split()[0]
            labels = {}
            
            # Parse labels if present
            if '{' in line and '}' in line:
                labels_start = line.find('{')
                labels_end = line.find('}')
                labels_str = line[labels_start + 1:labels_end]
                
                # Extract base metric name without labels
                metric_name = line.split('{')[0]
                
                # Parse individual label key=value pairs
                for label_pair in labels_str.split(','):
                    if '=' in label_pair:
                        key, value = label_pair.split('=', 1)
                        # Remove quotes from value
                        value = value.strip().strip('"')
                        labels[key.strip()] = value
            
            # Skip histogram/summary quantiles and special metrics
            if metric_name.endswith('_bucket') or metric_name.endswith('_sum') or \
               metric_name.endswith('_count') or metric_name.endswith('_total'):
                base_name = metric_name.rsplit('_', 1)[0]
                category = base_name
            else:
                # Use hierarchical categorization
                parts = metric_name.split('_')
                if len(parts) > 1:
                    category = '_'.join(parts[:2])
                else:
                    category = "other"
            
            categories[category].append({
                'name': metric_name,
                'help': current_help.get(metric_name, ''),
                'type': current_type.get(metric_name, ''),
                'labels': labels
            })
    
    return categories

def generate_markdown(categories):
    output = []
    
    for category, metrics in sorted(categories.items()):
        output.append(f"## {category.upper()} Metrics\n")
        output.append("| Metric Name | Type | Description |")
        output.append("|-------------|------|-------------|")
        
        for metric in sorted(metrics, key=lambda x: x['name']):
            # Clean up the help text for markdown
            help_text = metric['help'].replace('|', '\\|')
            output.append(f"| `{metric['name']}` | {metric['type']} | {help_text} |")
        
        output.append("")  # Empty line between categories
    
    return '\n'.join(output)

def get_filename(url):
    """Get filename from user input with default suggestion"""
    try:
        hostname = url.split('//')[1].split(':')[0]
        default_name = f"metrics_{hostname}.md"
    except:
        default_name = "metrics_output.md"
    
    user_input = input(f"Enter name of save file (enter to use '{default_name}'): ").strip()
    return user_input if user_input else default_name

def save_to_file(content, filename):
    """Save content to specified filename"""
    with open(filename, 'w') as f:
        f.write(content)
    print(f"Saved to {filename}")

def build_metrics_url(target):
    """Build proper metrics URL from hostname or full URL"""
    if target.startswith(('http://', 'https://')):
        return target
    else:
        # Remove port if included in hostname
        hostname = target.split(':')[0]
        return f"http://{hostname}:9100/metrics"

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 metric_parser.py <hostname_or_url>")
        print("Examples:")
        print("  python3 metric_parser.py hostname")
        print("  python3 metric_parser.py http://hostname:9100/metrics")
        print("  python3 metric_parser.py 192.168.1.100:9090")
        sys.exit(1)
    
    target = sys.argv[1]
    url = build_metrics_url(target)
    print(f"Fetching metrics from {url}...")
    
    metrics_text = parse_metrics(url)
    filename = get_filename(url)
    categories = categorize_metrics(metrics_text)
    markdown = generate_markdown(categories)
    
    print("\n" + "="*50)
    print(markdown)
    
    save_to_file(markdown, filename)
if __name__ == "__main__":
    main()
