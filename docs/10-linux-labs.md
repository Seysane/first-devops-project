# Lesson 10 Exercise 3: Manual Merge Conflict Resolution

This file documents my practical laboratory work with creating, understanding, and manually resolving a merge conflict in Git. Instead of doing this in a separate folder, I executed the entire simulation directly inside my main repository to keep all my lesson artifacts organized.

---

## 1. Laboratory Setup & Conflict Generation

To simulate a real-world collision where two engineers modify the exact same line in the exact same file, I followed these steps:

1. **Baseline Creation (`master`)**: I created a file named `readme.txt` with 3 baseline lines of text and committed it.
2. **Branch Isolation (`branch-A`)**: I created and switched to `branch-A`, then used `sed` to change Line 2 to add a simulated **login** feature. I saved and committed this change.
3. **Trunk Modification (`master`)**: I switched back to the `master` branch and changed the exact same Line 2 to add a simulated **monitoring** feature instead. I saved and committed this change.

---

## 2. Triggering the Conflict

Being on the `master` branch, I ran the merge command to pull in the changes from `branch-A`:

```bash
sane@power-sane:~/first-devops-project$ git merge branch-A
Auto-merging readme.txt
CONFLICT (content): Merge conflict in readme.txt
Automatic merge failed; fix conflicts and then commit the result.
```

## 2. Triggering the Conflict

Being on the `master` branch, I ran the merge command to pull in the changes from `branch-A`:

```bash
sane@power-sane:~/first-devops-project$ git merge branch-A
Auto-merging readme.txt
CONFLICT (content): Merge conflict in readme.txt
Automatic merge failed; fix conflicts and then commit the result.
```

As expected, Git halted the automatic merge process because the algorithmic engine encountered overlapping changes on Line 2 and did not know which version should take priority.

3. Analyzing Conflict Markers

When I opened readme.txt using the nano editor, Git had injected the following explicit layout boundaries into the file:

```Plaintext
Line 1: Welcome in the project
<<<<<<< HEAD
Line 2: Change from master - added monitoring
=======
Line 2: Change from branch-A - added login
>>>>>>> branch-A
Line 3: End of a file
```

What these markers mean:

```text
    <<<<<<< HEAD: This indicates the start of the changes on my current active branch (master), where I added monitoring.

    =======: This is the dividing line separating the two conflicting versions of the file.

    >>>>>>> branch-A: This marks the end of the incoming changes coming from the branch I am trying to merge (branch-A), where login was added.
```

4. Manual Resolution and Verification

Using the text editor, I manually stripped away the technical Git markers (<<<<<<<, =======, >>>>>>>) and cleanly unified the logic into a single, comprehensive line so that both features coexist peacefully.
Final rectified state of readme.txt:

```text
Line 1: Welcome in the project
Line 2: Added login and monitoring
Line 3: End of a file
```

After repairing the file, I staged it and completed the merge tracking cycle with a final commit:

```bash
sane@power-sane:~/first-devops-project$ git add readme.txt
sane@power-sane:~/first-devops-project$ git commit -m "Merge branch-A: unified login and monitoring feaures"
[master 1155335] Merge branch-A: unified login and monitoring feaures
```

5. Actual Repository Tree Log

Running the advanced graph history lookup command proves that the conflict was successfully bypassed and the two historical development tracks have successfully converged back into the main timeline:

```bash
sane@power-sane:~/first-devops-project$ git log --oneline --graph --all
* 1155335 (HEAD -> master) Merge branch-A: unified login and monitoring feaures
|\  
| * b515cf6 (branch-A) branch-A: line 2 changes - login
* | 57d6a24 master: line 2 changes - monitoring
|/  
* 7e637a7 Lab10: Beginning version for conflict file lesson
```

This structural execution output provides solid documentation that I can safely navigate parallel codebase updates, decode low-level block markers, and execute manual repository triage without losing development history.
