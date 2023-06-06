import os
import re
import subprocess
import sys

tgstation = "tgstation"
us = "maplestation"

tgstation_dme = tgstation + ".dme"
our_dme = us + ".dme"

tgstation_files = "code"
tgstation_ui_files = "tgui"
our_files = us + "_modules"

tgstation_build_path = "tools/build/build.js"

conflict_pattern = r'<<<<<<<\s.*?\n(.*?)=======\n(.*?)>>>>>>>\s.*?\n'

valid_filetypes = [
    ".dm",
    ".js",
    ".tsx",
    ".json", # Technically invalid, but we use it to produce a unique error message
    ".md",
    ".svg",
    ".yml",
    ".py",
    ".txt",
    ".sql",
    ".php",
    ".sh",
    ".ps1",
    ".css",
    ".scss",
    ".html",
]

def checkout_theirs(filepath: str):
    subprocess.run(["git", "checkout", "--theirs", filepath], stdin = subprocess.DEVNULL, stdout = subprocess.DEVNULL, stderr = subprocess.DEVNULL)

def is_valid_file(filepath: str):
    for filetype in valid_filetypes:
        if filepath.endswith(filetype):
            return True
    return False

def solve_file_conflicts(filepath: str):
    with open(filepath, "r", encoding = "utf-8") as checked_file:
        checked_file_contents = checked_file.read()

    if "<<<<<<<" not in checked_file_contents:
        return 0

    if re.search(r'\/{2,}\s*non(\s|-)*module', checked_file_contents, flags = re.IGNORECASE):
        print("\nNon-module edit found in " + filepath + ", and must be resolved manually.")
        return 0

    if filepath.endswith(".json"):
        if not filepath.endswith("package.json"):
            print("\nJSON file requires manual attention for edits: " + filepath)
            return 0

    if os.path.isfile(".git/index.lock"):
        print("Git index lock exists, possible error detected")
        os.sys.remove(".git/index.lock")

    # This is really slow, should batch it.
    checkout_theirs(filepath)
    # print("Resolved conflicts in " + filepath)
    return 1

def solve_conflicts_in_dir(dir: str, exclude_subdirs: list = []):
    total_resolved = 0
    for root, subdirs, files in os.walk(dir):
        for other_dir in exclude_subdirs:
            if other_dir in subdirs:
                subdirs.remove(other_dir)

        for file in files:
            path = os.path.join(root, file)
            if not is_valid_file(file):
                continue

            try:
                total_resolved += solve_file_conflicts(path)
            except:
                print("Error resolving conflicts in " + path)

            if total_resolved % 4 == 0:
                print(".", end = "")

    print("\n\"Solve conflicts\" in dir " + dir + " done - Total conflicts resolved: " + str(total_resolved))

def find_unticked_files(dir: str):
    if not dir:
        print("No directory specified")
        return

    ticked_files = []
    with open(tgstation_dme, "r", encoding = "utf-8") as dme_f:
        for line in dme_f:
            if line.startswith("//"):
                continue

            match = re.search(r'#include "(.+)"', line)
            if match:
                ticked_files.append(match.group(1))

    files_removed = 0
    files_iterated = 1
    for root, subdirs, files in os.walk(dir):
        if "tgs" in subdirs:
            subdirs.remove("tgs")
        if "unit_tests" in subdirs:
            subdirs.remove("unit_tests")

        for file in files:
            if not file.endswith(".dm"):
                continue

            files_iterated += 1
            if files_iterated % 4 == 0:
                print(".", end = "")

            path = os.path.join(root, file)
            if path in ticked_files:
                continue
            os.remove(path)
            print("\nFile not found in dme, removing: " + path)
            files_removed += 1

    print("\n\"Find Unticked\" done - total iterated " + str(files_iterated) + ", removed " + str(files_removed))

def update_dme():
    checkout_theirs(tgstation_dme)
    num_old = 0
    num_new = 0
    combined_files = ""
    with open(tgstation_dme, "r", encoding = "utf-8") as new_dme:
        for line in new_dme:
            if "<<<<<<<" in line:
                print("Conflict found in DME file, aborting")
                return
            if "// END_INCLUDE" in line:
                break
            combined_files += line
            if not line.startswith("//"):
                num_old += 1

    with open(our_dme, "r", encoding = "utf-8") as old_dme:
        for line in old_dme:
            if our_files not in line:
                continue
            combined_files += line
            num_new += 1

    combined_files += "// END_INCLUDE\n"
    with open(our_dme, "w", encoding = "utf-8") as old_dme:
        old_dme.write(combined_files)

    print("\"Update DME\" Done - tg dme " + str(num_old) + ", our dme " + str(num_new))

def update_build():
    checkout_theirs(tgstation_build_path)

    with open(tgstation_build_path, "r+", encoding = "utf-8") as build_file:
        build_file_text = build_file.read()
        build_file_text = build_file_text.replace(tgstation, us)
        build_file.seek(0)
        build_file.write(build_file_text)
        build_file.truncate()

    print("\"Update build\" done")
    # This should also update CI

if __name__ == "__main__":
    print("Running merge driver.")

    # try:
    #     upstream_origin = sys.argv[1]
    # except IndexError:
    #     print("No upstream origin specified, using default: \"upstream-tg\"")
    #     upstream_origin = "upstream-tg"

    # subprocess.run(["git", "fetch", upstream_origin, "master"])
    # subprocess.run(["git", "pull", upstream_origin, "master", "--allow-unrelated-histories"])

    # print("=== 1. Resolving conflicts automatically... ===")
    # solve_conflicts_in_dir(tgstation_files)
    # solve_conflicts_in_dir(tgstation_ui_files)

    # print("=== 2. Updating dme... ===")
    # update_dme()

    # print("=== 3. Updating build... ===")
    # update_build()

    print("=== 4. Removing unticked files... ===")
    find_unticked_files(tgstation_files)

    # print("=== 5. Cleaing up misc files... ===")
    # solve_conflicts_in_dir(".", [tgstation_files, tgstation_ui_files])

    print("Merge driver done.")
