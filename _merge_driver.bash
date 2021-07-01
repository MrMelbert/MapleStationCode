#!/bin/bash

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

	for file in $(find $1 -name "*.dm" -or -name "*.js" -type f); do
		if ! grep -q "<<<<<<<" "$file"; then
			continue
		fi

		if grep -q -i -E "\/{2,}\s*non(\s|-)*module" "$file"; then
			echo "NOTICE: $file contains modular changes, and must be done manually."
			continue
		fi

		sed -i '/<<<<<<</,/=======/d' "$file"
		sed -i '/>>>>>>>/d' "$file"
		echo "$file merge conflicts resolved."
	done

	echo "Done searching dir: $1."
	return 0
}

update_dme (){

	if [ ! -f $1 ]; then
		echo "!! update_dme error: $1 file not found. This should be the new tgstation.dme."
		return 1
	fi

	if [ ! -f $2 ]; then
		echo "!! update_dme error:: $2 file not found. This should be the old jollystation.dme."
		return 1
	fi

	tempfile=temp_"$1"
	sed '$d' $1 >> $tempfile
	grep '#include "jollystation_modules' $2 >> $tempfile
	echo "// END_INCLUDE" >> $tempfile
	cp $tempfile $2
	rm $tempfile
	echo "Done updating dme."
	return 0
}

update_build (){
	sed -i 's/tgstation/jollystation/g' tools/build/build.js
	return 0
}

echo "Running merge driver. . ."
find_all_in_dir "code"
find_all_in_dir "tgui"
echo "Conflict checking done. Updating DME."
update_dme tgstation.dme jollystation.dme
echo "DME update down. Updating build.js"
update_build
echo "All tasks done."
