# Lesson 10 Exercise 2.

## Remote Collaboration Report (Push, Pull, PR)

This file documents my hands-on practice with remote Git operations during Lesson 10. To simulate working with another developer in a real DevOps team, I cloned my repository into a second folder called `~/colleague_project` on my workstation.

---

## Pushing Code (`git push`)
When you create a new feature branch locally, GitHub doesn't know about it yet. You need to push it to the remote server (`origin`) and tell Git to track it:


#### First push of a new branch (sets upstream tracking)
```bash
git push -u origin feature/api-docs
```
#### Next pushes on the same branch
```bash
git push
```

## Fetching vs Pulling (git fetch vs git pull)


* git fetch origin : This is the safe way. It downloads all new info and branches from GitHub, but it DOES NOT touch or change your local files. It just updates Git's internal map.



* git pull origin master: This is a compound command. It first runs git fetch, and then immediately tries to merge the remote changes into your active local branch. It directly updates your files.

### 2. Pull Request (PR) Workflow on GitHub

A Pull Request is how we ask the team to check our code before it goes into the main branch. Here is the process I followed:

    Push the branch: I pushed feature/api-docs to GitHub.

    Open PR: On the GitHub page, I selected master as the target (base) branch and feature/api-docs as the source (compare) branch.

    Add Title and Description: I wrote a short summary explaining that this branch adds the initial API documentation layout.

    Merge: After a simulated review, I clicked "Merge pull request" on GitHub to merge the code into the master branch.

### 3. Cleaning Up Branches After Merge

To keep the repository clean and avoid "branch spam", it is important to delete feature branches after they are successfully merged.

### 1. Switch back to master and get the newly merged code from GitHub
```bash
git checkout master
git pull origin master
```

### 2. Delete the feature branch locally (safe delete)
```bash
git branch -d feature/api-docs
```

### 3. Delete the tracking branch on the GitHub server
```bash
git push origin --delete feature/api-docs
```
