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

def validate_dirs(dirs: list):
    if "tgs" in dirs:
        dirs.remove("tgs")
    if "unit_tests" in dirs:
        dirs.remove("unit_tests")

def is_valid_file(filepath: str):
    return filepath.endswith(".dm") or filepath.endswith(".js") or filepath.endswith(".tsx")

def solve_file_conflicts(filepath: str):
    with open(filepath, "r", encoding = "utf-8") as checked_file:
        checked_file_contents = checked_file.read()

    if "<<<<<<<" not in checked_file_contents:
        return 0

    if re.search(r'\/{2,}\s*non(\s|-)*module', checked_file_contents):
        print("Non-module edit found in " + filepath + ", and must be resolved manually.")
        return 0

    conflict_sections = re.findall(
        f'{conflict_start_pattern}(.*?){conflict_middle_pattern}(.*?){conflict_end_pattern}',
        checked_file_contents,
        flags = re.DOTALL
    )

    resolved = 0
    for conflict in conflict_sections:
        incoming_changes = conflict[1]
        checked_file_contents = checked_file_contents.replace(''.join(conflict), incoming_changes)
        resolved += 1

    with open(filepath, "w", encoding = "utf-8") as checked_file:
        checked_file.write(checked_file_contents)

    print("Conflicts resolved in " + filepath)
    return resolved

def solve_conflicts_in_dir(dir: str):
    total_resolved = 0
    for root, subdirs, files in os.walk(dir):
        validate_dirs(subdirs)
        for file in files:
            if not is_valid_file(file):
                continue

            path = os.path.join(root, file)
            try:
                total_resolved += solve_file_conflicts(path)
            except:
                print("Error resolving conflicts in " + path)

    print("\"Sovlve conflicts\" in dir " + dir + " done - Total conflicts resolved: " + str(total_resolved))

def find_unticked_files(dir: str):
    if not dir:
        print("No directory specified")
        return

    ticked_files = []
    with open(tgstation_dme, "r", encoding = "utf-8") as dme_f:
        for line in dme_f:
            match = re.search(r'([\w.-]+\.dm)', line)
            if match:
                ticked_files.append(match.group(1))

    files_removed = 0
    files_iterated = 1
    for root, subdirs, files in os.walk(dir):
        validate_dirs(subdirs)
        for file in files:
            if not is_valid_file(file):
                continue

            files_iterated += 1
            if file in ticked_files:
                continue
            path = os.path.join(root, file)
            # os.remove(path)
            print("File not found in dme, removing: " + path)
            files_removed += 1

    print("\"Find Unticked\" done - total iterated " + str(files_iterated) + ", removed " + str(files_removed))

def update_dme():
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
    with open(tgstation_build_path, "r+", encoding = "utf-8") as build_file:
        build_file_text = build_file.read()
        build_file_text = build_file_text.replace(tgstation, us)
        build_file.seek(0)
        build_file.write(build_file_text)
        build_file.truncate()
    print("\"Update build\" done")

if __name__ == "__main__":
    print("Running merge driver.")

    print("=== 1. Resolving conflicts automatically... ===")
    solve_conflicts_in_dir(tgstation_files)
    solve_conflicts_in_dir(tgstation_ui_files)

    print("=== 2. Updating dme... ===")
    update_dme()

    print("=== 3. Updating build... ===")
    update_build()

    print("=== 4. Removing unticked files... ===")
    find_unticked_files(tgstation_files)

    print("Merge driver done.")
