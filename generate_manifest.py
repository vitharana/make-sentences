import os
import json

def generate_manifest():
    templates_dir = 'templates'
    manifest_path = os.path.join(templates_dir, 'manifest.json')
    
    if not os.path.exists(templates_dir):
        print(f"Error: The '{templates_dir}' directory does not exist. Please create it first.")
        return

    manifest_data = []

    for file_name in sorted(os.listdir(templates_dir)):
        if file_name.endswith('.json') and file_name != 'manifest.json':
            base_name = os.path.splitext(file_name)[0]
            clean_title = base_name.replace('_', ' ').replace('-', ' ').title()
            formatted_title = f"📚 {clean_title}"
            
            template_entry = {
                "title": formatted_title,
                "filePath": f"{templates_dir}/{file_name}"
            }
            
            manifest_data.append(template_entry)
            print(f"Added to manifest: {formatted_title} -> {template_entry['filePath']}")

    with open(manifest_path, 'w', encoding='utf-8') as manifest_file:
        json.dump(manifest_data, manifest_file, indent=2, ensure_ascii=False)
        
    print(f"\nSuccess! manifest.json has been updated with {len(manifest_data)} templates.")

if __name__ == '__main__':
    generate_manifest()