walker Supervisor {
    input string repo_url;
    output string docs_path;

    method run() {
        // Step 1: Map the repository
        var repo_mapper = new RepoMapper();
        repo_mapper.repo_url = repo_url;

        // Generate the file tree of the repository
        var file_tree = repo_mapper.generate_file_tree();

        // Step 2: Analyze the code to build a Code Context Graph (CCG)
        var code_analyzer = new CodeAnalyzer();
        code_analyzer.repo_files = file_tree;

        // Perform the code analysis
        var ccg = code_analyzer.analyze_code();

        // Step 3: Generate the markdown documentation
        var doc_genie = new DocGenie();
        doc_genie.file_tree = file_tree;
        doc_genie.ccg = ccg;

        // Generate the markdown documentation content
        var markdown_doc = doc_genie.generate_markdown();

        // Step 4: Save the generated documentation to a file
        var repo_name = repo_url.split("/").last(); // Extract the repo name from the URL
        var docs_path = "./outputs/" + repo_name + "/docs.md";

        // Ensure the output directory exists
        system("mkdir -p ./outputs/" + repo_name);

        // Save the markdown content to the documentation file
        system("echo '" + markdown_doc + "' > " + docs_path);

        // Return the path to the generated documentation file
        return docs_path;
    }
}
