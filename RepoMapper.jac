walker RepoMapper {
    has input string repo_url
    has output list<string> file_tree

    // Method to generate the file tree
    method generate_file_tree() {
        // Clone the GitHub repository using a system command
        var repo_name = repo_url.split("/").last()
        var temp_dir = "/tmp/" + repo_name
        
        // Clone the repository
        system("git clone " + repo_url + " " + temp_dir)

        // Traverse the repository directory and generate a list of files
        // Ignore irrelevant folders like .git or node_modules
        var files = []
        var dirs_to_ignore = [".git", "node_modules"]

        // Use system command to get the list of files
        system("find " + temp_dir + " -type f").each { file ->
            // Check if the file contains any of the directories to ignore
            if (!dirs_to_ignore.any { file.contains(it) }) {
                files.add(file)
            }
        }

        // Return the list of files in the repository
        return files
    }
}
