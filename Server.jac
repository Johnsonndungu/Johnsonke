# Import necessary libraries (if needed)
import from tools {Supervisor, RepoMapper};

# Define a node for handling the server
node Server {

    # Method to start the server
    method start() {
        # Start the HTTP server on localhost:8080
        server.listen(8080, "localhost");
    }

    # Route to handle generating documentation for a repository
    can handle_generate_docs with route("/generate-docs", method="POST") {
        # Parse the incoming JSON request body
        var json_data = request.body.json();
        var repo_url = json_data["repo_url"];

        # Initialize Supervisor to process the repository
        var supervisor = new Supervisor();
        supervisor.repo_url = repo_url;

        # Run the supervisor to generate documentation
        var docs_path = supervisor.run();

        # Return the path to the generated documentation as a JSON response
        return response.json({ "docs_path": docs_path });
    }

    # Route to handle generating the file tree for the repository
    can handle_repo_map with route("/repo-map", method="GET") {
        # Get the repository URL from the query string
        var repo_url = request.query["repo_url"];

        # Initialize RepoMapper to generate the file tree
        var repo_mapper = new RepoMapper();
        repo_mapper.repo_url = repo_url;

        # Generate the file tree of the repository
        var file_tree = repo_mapper.generate_file_tree();

        # Return the file tree as a JSON response
        return response.json({ "file_tree": file_tree });
    }
}

# Run the server node
server.start();
