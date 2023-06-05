import os
import re

tgstation = "tgstation"
us = "maplestation"

tgstation_dme = tgstation + ".dme"
our_dme = us + ".dme"

tgstation_files = "code"
tgstation_ui_files = "tgui"
our_files = us + "_modules"

tgstation_build_path = "tools/build/build.js"

conflict_start_pattern = r'<<<<<<<\s.*?\n'
conflict_middle_pattern = r'=======\n'
conflict_end_pattern = r'>>>>>>>.*?\n'

def solve_file_conflicts(filepath: str):
    with open(filepath, "r") as checked_file:
        checked_file_contents = checked_file.read()

    if re.search(r'\/{2,}\s*non(\s|-)*module', checked_file_contents):
        print("Non-module edit found in " + filepath + ", and must be resolved manually.")
        return

    conflict_sections = re.findall(
        f'{conflict_start_pattern}(.*?){conflict_middle_pattern}(.*?){conflict_end_pattern}',
        checked_file_contents,
        flags = re.DOTALL
    )

    for conflict in conflict_sections:
        incoming_changes = conflict[1]
        checked_file_contents = checked_file_contents.replace(''.join(conflict), incoming_changes)

    with open(filepath, "w") as checked_file:
        checked_file.write(checked_file_contents)

def solve_conflicts_in_dir(dir: str):
    for root, subdirs, files in os.walk(dir):
        if "tgs" in subdirs:
            subdirs.remove("tgs")
        if "unit_tests" in subdirs:
            subdirs.remove("unit_tests")

        for file in files:
            path = os.path.join(root, file)
            try:
                solve_file_conflicts(path)
            except:
                print("Error resolving conflicts in " + path)

def find_unticked_files(dir: str):
    if not dir:
        print("No directory specified")
        return

    ticked_files = []
    with open(tgstation_dme, "r") as dme_f:
        for line in dme_f:
            match = re.search(r'([\w.-]+\.dm)', line)
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
            if files_iterated % 3 == 0:
                print(".", end = "")
            if file in ticked_files:
                continue
            path = os.path.join(root, file)
            # os.remove(path)
            print("\nFile not found in dme, removing: " + path)
            files_removed += 1

    print("\n\"Find Unticked\" Done - total iterated " + str(files_iterated) + ", removed " + str(files_removed))

def update_dme():
    num_old = 0
    num_new = 0
    combined_files = ""
    with open(tgstation_dme, "r") as new_dme:
        for line in new_dme:
            if "<<<<<<<" in line:
                print("Conflict found in DME file, aborting")
                return
            if "// END_INCLUDE" in line:
                break
            combined_files += line
            if not line.startswith("//"):
                num_old += 1

    with open(our_dme, "r") as old_dme:
        for line in old_dme:
            if our_files not in line:
                continue
            combined_files += line
            num_new += 1

    combined_files += "// END_INCLUDE\n"
    print("\n\"Update DME\" Done - tg dme " + str(num_old) + ", our dme " + str(num_new))

    with open(our_dme, "w") as old_dme:
        old_dme.write(combined_files)

def update_build():
    with open(tgstation_build_path, "r+") as build_file:
        build_file_text = build_file.read()
        build_file_text = build_file_text.replace(tgstation, us)
        build_file.seek(0)
        build_file.write(build_file_text)
        build_file.truncate()

if __name__ == "__main__":
    print("Running merge driver.")

    print("=== 1. Resolving conflicts automatically... ===")
    solve_file_conflicts(tgstation_files)
    solve_file_conflicts(tgstation_ui_files)

    print("=== 2. Updating dme... ===")
    update_dme()

    print("=== 3. Updating build... ===")
    update_build()

    print("=== 4. Removing unticked files... ===")
    find_unticked_files(tgstation_files)

    print("Merge driver done.")
