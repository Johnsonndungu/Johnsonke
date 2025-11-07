import streamlit as st
import requests
import time

# --- CONFIG ---
BASE_URL = "http://localhost:5000"  # URL of the backend API

# --- STYLE ---
st.set_page_config(page_title="Codebase Genius", layout="wide")
st.markdown(
    """
    <style>
    .header { font-size: 2rem; font-weight: bold; }
    .message-box { background: #f7f7f9; padding: 10px; border-radius: 5px; margin-bottom: 10px; }
    .loading { color: #FF5733; font-size: 1.2rem; }
    </style>
    """, 
    unsafe_allow_html=True
)

# --- STREAMLIT UI ---
st.title("Codebase Genius — GitHub Repo Documentation Generator")

# GitHub Repository URL input
repo_url = st.text_input("Enter GitHub Repository URL", placeholder="https://github.com/username/repo")

# Button to trigger the documentation generation
submit_button = st.button("Generate Documentation")

# Handle submission
if submit_button:
    if not repo_url:
        st.error("Please provide a valid GitHub repository URL.")
    else:
        with st.spinner("Generating documentation... This may take a few minutes"):
            # Call the backend API to start the documentation generation process
            response = requests.post(
                f"{BASE_URL}/generate-docs",
                json={"repo_url": repo_url}
            )

            if response.status_code == 200:
                data = response.json()
                docs_path = data.get("docs_path", "")
                
                if docs_path:
                    st.success(f"Documentation generated successfully! You can download it from the link below.")
                    # Provide a download button for the generated docs
                    with open(docs_path, "r") as f:
                        docs_content = f.read()

                    st.download_button(
                        label="Download Documentation",
                        data=docs_content,
                        file_name="docs.md",
                        mime="text/markdown"
                    )
                else:
                    st.error("There was an issue generating the documentation.")
            else:
                st.error("Error occurred while processing the repository. Please try again later.")

# --- Display repository structure (if available) ---
if repo_url:
    try:
        # Optionally, display a file-tree view here
        response = requests.get(f"{BASE_URL}/repo-map", params={"repo_url": repo_url})
        if response.status_code == 200:
            file_tree = response.json().get("file_tree", [])
            if file_tree:
                st.subheader("Repository File Tree")
                for file in file_tree:
                    st.text(file)
        else:
            st.warning("Failed to fetch the repository file structure.")
    except requests.exceptions.RequestException as e:
        st.error(f"Error fetching repository details: {e}")
