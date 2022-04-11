#!/bin/bash

# print all files that aren't ticked in tgstation.dme
#
# supply one argument: the directory to search
find_unticked_files (){

	if [ ! -d $1 ]; then
		echo "!! find_unticked_files error: $1 directory not found."
		return 1
	fi

	NEED_NEWLINE=1
	NUM_DOTS=0
	for file in $(find $1 -name "*.dm" -type f); do
		if [ ! -f $file ]; then
			continue
		fi

		if grep -q "/datum/unit_test" $file; then # Unit tests are not ticked
			continue
		fi
		if grep -q "/datum/tgs_api" $file; then # TGS are not ticked either (I think)
			continue
		fi

		FILE_NAME="$(echo $file | sed -e 's,/,\\,g')"
		if ! grep -q -i -F "$FILE_NAME" tgstation.dme; then
			if [ "$NEED_NEWLINE" -eq "1" ]; then
				echo ""
				NEED_NEWLINE=0
			fi
			echo "$FILE_NAME was found to not be in tgstation.dme / unticked!"
			rm $file
			NUM_DOTS=0
		else
			NEED_NEWLINE=1
			let NUM_DOTS++
			if ! (($NUM_DOTS % 3)); then
				echo -ne "."
			fi
			if [ "$NUM_DOTS" -ge "270" ]; then
				echo ""
				NUM_DOTS=0
			fi
		fi

	done
	echo ""
	echo "Done search dir and all subdirs: $1."
	return 0
}

# find all files with merge conflicts in the supplied directory
# if no non-module comments are present, automatically resolve the merge conflict (accept incoming)
#
# supply one argument: the directory to search
find_all_in_dir (){

	if [ ! -d $1 ]; then
		echo "!! find_all_in_dir error: $1 directory not found."
		return 1
	fi

	for file in $(find $1 -name "*.json" -type f); do
		if grep -q "<<<<<<<" "$file"; then
			echo "NOTICE: Special case file $file caught, and must be handled manually."
		fi
	done

	NEED_NEWLINE=1
	NUM_DOTS=0
	for file in $(find $1 -name "*.dm" -or -name "*.js" -type f); do
		if [ ! -f $file ]; then
			continue
		fi

		if ! grep -q "<<<<<<<" "$file"; then
			NEED_NEWLINE=1
			let NUM_DOTS++
			if ! (($NUM_DOTS % 3)); then
				echo -ne "."
			fi
			if [ "$NUM_DOTS" -ge "270" ]; then
				echo ""
				NUM_DOTS=0
			fi
			continue
		fi

		if [ "$NEED_NEWLINE" -eq "1" ]; then
			echo ""
			NEED_NEWLINE=0
			NUM_DOTS=0
		fi

		if grep -q -i -E "\/{2,}\s*non(\s|-)*module" "$file"; then
			echo "NOTICE: $file contains modular changes, and must be done manually."
			continue
		fi

		sed -i '/<<<<<<</,/=======/d' "$file"
		sed -i '/>>>>>>>/d' "$file"
		echo "$file merge conflicts resolved."
	done

	echo ""
	echo "Done resolving dir and all subdirs: $1."
	return 0
}

# updates the DME to the new version
#
# supply two arguments: the new tgstation.dme, and the old maplestation.dme
update_dme (){

	if [ ! -f $1 ]; then
		echo "!! update_dme error: $1 file not found. This should be the new tgstation.dme."
		return 1
	fi

	if [ ! -f $2 ]; then
		echo "!! update_dme error:: $2 file not found. This should be the old maplestation.dme."
		return 1
	fi

	if grep -q "<<<<<<<" $1; then
		sed -i '/<<<<<<</,/=======/d' $1
		sed -i '/>>>>>>>/d' $1
		echo "$1 merge conflicts resolved before updating modular DME.."
	fi

	tempfile=temp_"$1"
	sed '$d' $1 >> $tempfile
	grep '#include "maplestation_modules' $2 >> $tempfile
	echo "// END_INCLUDE" >> $tempfile
	cp $tempfile $2
	rm $tempfile
	echo "Done updating dme."
	return 0
}

#update the build file
update_build (){
	sed -i 's/tgstation/maplestation/g' tools/build/build.js
	return 0
}

echo "Running merge driver. . ."
echo "====================================================================================="
echo "Do you want to find and remove unticked files? This takes a long time. It also may potentially delete core files by accident. (Y / N)"
read unticked_input
if [ "$unticked_input" == 'y' ]; then
	echo "Looking for unticked files. . ."
	find_unticked_files "code"
	echo "Unticked files done."
fi
echo "====================================================================================="
echo "Checking for merge conflicts. . ."
find_all_in_dir "code"
find_all_in_dir "tgui"
echo "Conflict checking done."
echo "====================================================================================="
echo "Updating DME. . ."
update_dme tgstation.dme maplestation.dme
echo "DME update done."
echo "====================================================================================="
echo "Updating build.js. . ."
update_build
echo "All tasks done."
