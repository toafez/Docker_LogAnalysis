#!/bin/bash
# Filename: main.sh - coded in utf-8

#                LogAnalysis für Docker
#    Copyright (C) 2025 by toafez (Tommes) | MIT License


# Reset page
# --------------------------------------------------------------
if [[ "${GETpage}" == "main" && "${GETsection}" == "reset" ]]; then
	[ -f "${get_request}" ] && rm "${get_request}"
	[ -f "${post_request}" ] && rm "${post_request}"
	echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=main&section=start">'
fi

# Load horizontal navigation bar
# --------------------------------------------------------------
mainnav

# Functions for displaying the directory tree
# --------------------------------------------------------------
rootdir()
{
	maindir="${app_logfile_dir}"
	dirlevel="0"
	tabstop="0"

    for subfolder in "${1}"; do

		# Show root directory
        echo '
		<a href="index.cgi?page=main&section=start&path='${folder}'&file=&query=" class="text-secondary text-decoration-none">
			<span class="text-secondary pe-1">
				<i class="bi bi-folder-fill text-secundary align-middle" style="font-size: 1.3rem;"></i>
				<small class="fw-bold">'${subfolder}'</small><small> '${txt_refers_to}'</small>'
				if [[ "${folder_attributes}" == "on" ]]; then
					foldersize=$(du -sb "${maindir}" | sed "s#/.*##")
					foldersize=$(bytesToHumanReadable "$foldersize")
					echo '
					<span class="float-end">
						<small><span class="text-secondary fw-bold">'${foldersize}'</span></small>
					</span>'
				fi
				echo '
			</span>
		</a>'

        if [ -d "${subfolder}" ]; then
            thisfolder=${subfolder}

			# Show all subdirectories of the root directory
			subdir $(ls ${thisfolder})

			# Show all files in the root directory
			subfiles "${thisfolder}"
        fi
    done
    unset tabstop
}

subdir()
{
	dirlevel=$[${dirlevel}+1]
    tabstop=$[${tabstop}+20]

    for folder in "${@}"; do

        thisfolder=${thisfolder}/${folder}

        # Show all subdirectories of the root directory (directory level 0)
		if [ -d "${thisfolder}" ]; then
			if [ -z "$(ls -A ${thisfolder})" ] && [[ -z "${folder_access}" || "${folder_access}" == "off" ]]; then
				echo '
				<a class="text-start text-secondary text-decoration-none" data-bs-toggle="collapse" href="#'${thisfolder}'" role="button" aria-expanded="false" aria-controls="'${thisfolder}'">
					<span style="margin-left: '${tabstop}'px;">
						<nobr>
							<span class="text-secondary align-middle pe-1" title="'${txtFolderWithoutContent}'">
								<i class="bi bi-folder text-warning" style="font-size: 1.3rem;"></i>
								<small style="cursor: not-allowed;">'${folder}'</small>
							</span>
						</nobr>'
						if [[ "${folder_attributes}" == "on" ]]; then
							foldersize=$(du -sb "${thisfolder}" | sed "s#/.*##")
							foldersize=$(bytesToHumanReadable "$foldersize")
							echo '
							<span class="float-end">
								<small><span class="text-secondary">'${foldersize}'</span></small>
							</span>'
						fi
						echo '
					</span>
				</a>'
			elif [ -n "$(ls -A ${thisfolder})" ]; then
				echo '
				<a class="text-start text-secondary text-decoration-none" data-bs-toggle="collapse" href="#'${thisfolder}'" role="button" aria-expanded="false" aria-controls="'${thisfolder}'">
					<span style="margin-left: '${tabstop}'px;">
						<nobr>
							<span class="text-secondary align-middle pe-1" title="'${txtFolderWithContent}'">
								<i class="bi bi-folder-fill text-warning" style="font-size: 1.3rem;"></i>
								<small style="cursor: pointer;">'${folder}'</small>'
								echo '
							</span>
						</nobr>'
						if [[ "${folder_attributes}" == "on" ]]; then
							foldersize=$(du -sb "${thisfolder}" | sed "s#/.*##")
							foldersize=$(bytesToHumanReadable "$foldersize")
							echo '
							<span class="float-end">
								<small><span class="text-secondary">'${foldersize}'</span></small>
							</span>'
						fi
						echo '
					</span>
				</a>'
			fi

			# Show all files in the root directory (directory level 0)
			if [[ "${dirlevel}" -eq 0 ]]; then
				subfiles "${thisfolder}"

			# Hide all subdirectories and files, except for the path to the selected file
			elif [[ "${dirlevel}" -ne 0 ]]; then

				# Extract the third directory name from the path, starting from the left
				subdir=$(echo "${GETfile%/*}" | awk -v FS='/' '{print $4}')

				# Show all files and subdirectories around the selected file
				if [[ "${thisfolder}" == "${GETfile%/*}" ]]; then
					echo '
					<div class="collapse.show" id="'${thisfolder}'">'
						subfiles "${thisfolder}"
						echo '
					</div>
					<div class="collapse.show" id="'${thisfolder}'">'
						subdir $(ls ${thisfolder})
						echo '
					</div>'

				# Hide all files in all other subdirectories
				else
					echo '
					<div class="collapse" id="'${thisfolder}'">'
						subfiles "${thisfolder}"
						echo '
					</div>'

					# Show all directorys and subdirectories around the selected file
					if [[ "${GETfile%/*}" == ${maindir}/${subdir}/* ]]; then
						if [[ "${thisfolder}" == ${maindir}/${subdir} ]]; then
							echo '
							<div class="collapse.show" id="'${thisfolder}'">'
								subdir $(ls ${thisfolder})
								echo '
							</div>'
						elif [[ "${thisfolder}" == ${maindir}/${subdir}/* ]]; then
							echo '
							<div class="collapse.show" id="'${thisfolder}'">'
								subdir $(ls ${thisfolder})
								echo '
							</div>'
						else
							echo '
							<div class="collapse" id="'${thisfolder}'">'
								subdir $(ls ${thisfolder})
								echo '
							</div>'
						fi

					# Hide directorys and subdirectories in all other subdirectories
					else
						echo '
						<div class="collapse" id="'${thisfolder}'">'
							subdir $(ls ${thisfolder})
							echo '
						</div>'
					fi
				fi
			fi
        fi
        thisfolder=${thisfolder%/*}
    done

    tabstop=$[${tabstop}-20]
	dirlevel=$[${dirlevel}-1]
}

subfiles()
{
	while IFS= read -r file; do
		[[ -z "${file}" ]] && continue
		tabstop=$[${tabstop}+20]
		if [[ "${file_attributes}" == "on" ]]; then
			filesize=$(du -sb "${file}" | sed "s#/.*##")
			filesize=$(bytesToHumanReadable "$filesize")
			permissions=$(ls -l "$file" | cut -d' ' -f1)
			lastmodified=$(date -r "$file" "+%Y-%m-%d %H:%M:%S")
		fi
		# Display of the files
		[[ "${file}" == "${GETfile}" ]] && boldtext="class=\"fw-bold\""
		if [[ "${file}" == *.xz || "${file}" == *.tgz || "${file}" == *.txz ]]; then
			if [ -z "${file_access}" ] || [[ "${file_access}" == "off" ]]; then
				echo '
				<div style="margin-left: '${tabstop}'px;">
					<div>
						<span class="text-warning align-middle pe-1" title="'${txtFileIsArchive}'" style="cursor: help;">
							<i class="bi bi-file-earmark-zip text-danger" style="font-size: 1.3rem;"></i>
						</span>
						<small class="text-danger" style="cursor: not-allowed;">'${file##*/}'</small>
					</div>'
					if [[ "${file_attributes}" == "on" ]]; then
						echo '
						<div style="border-bottom:1px #cccccc solid;">
							<small><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
							<span class="float-end">
								<small><span class="text-secondary">'${filesize}'</span></small>
							</span>
						</div>'
					fi
					echo '
				</div>'
			fi
		elif [ ! -r "${file}" ]; then
			if [ -z "${file_access}" ] || [[ "${file_access}" == "off" ]]; then
				echo '
				<div style="margin-left: '${tabstop}'px;">
					<div>
						<span class="text-secondary align-middle pe-1" title="'${txtFileNoReadingRights}'" style="cursor: help;">
							<i class="bi bi-file-earmark-x text-danger" style="font-size: 1.3rem;"></i>
						</span>
						<small class="text-danger" style="cursor: not-allowed;">'${file##*/}'</small>
					</div>'
					if [[ "${file_attributes}" == "on" ]]; then
						echo '
						<div style="border-bottom:1px #cccccc solid;">
							<small><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
							<span class="float-end">
								<small><span class="text-secondary">'${filesize}'</span></small>
							</span>
						</div>'
					fi
					echo '
				</div>'
			fi
		elif [ ! -w "${file}" ]; then
			echo '
			<div style="margin-left: '${tabstop}'px;">
				<div>
					<a href="index.cgi?page=main&section=start&query=view&path='${GETpath}'&file='${file}'" class="text-secondary text-decoration-none">
						<span class="text-secondary align-middle pe-1" title="'${txtFileNoWritingRights}'" style="cursor: help;">
							<i class="bi bi-file-earmark-font text-warning" style="font-size: 1.3rem;"></i>
						</span>
						<small '${boldtext}' style="cursor: pointer;">'${file##*/}'</small>
					</a>
				</div>'
				if [[ "${file_attributes}" == "on" ]]; then
					echo '
					<div style="border-bottom:1px #cccccc solid;">
						<small '${boldtext}'><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
						<span class="float-end">
							<small '${boldtext}'><span class="text-secondary">'${filesize}'</span></small>
						</span>
					</div>'
				fi
				echo '
			</div>'
		else
			echo '
			<div style="margin-left: '${tabstop}'px;">
				<div>
					<a href="index.cgi?page=main&section=start&query=view&path='${GETpath}'&file='${file}'" class="text-secondary text-decoration-none">
						<span class="text-secondary align-middle pe-1" title="'${txtFileOpen}'" style="cursor: help;">
							<i class="bi bi-file-earmark-font text-success" style="font-size: 1.3rem;"></i>
						</span>
							<small '${boldtext}' style="cursor: pointer;">'${file##*/}'</small>
					</a>
				</div>'
				if [[ "${file_attributes}" == "on" ]]; then
					echo '
					<div style="border-bottom:1px #cccccc solid;">
						<small '${boldtext}'><span class="text-secondary" style="padding-left:25px;">'${lastmodified}'</span></small>
						<span class="float-end">
							<small '${boldtext}'><span class="text-secondary">'${filesize}'</span></small>
						</span>
					</div>'
				fi
				echo '
			</div>'
		fi
		unset boldtext
		tabstop=$[${tabstop}-20]
	done <<< "$( find ${1} -maxdepth 1 -type f | sort )"
}

# Load library function for byte conversion
# --------------------------------------------------------------
[ -f "${app_home_dir}/modules/bytes2human.sh" ] && source "${app_home_dir}/modules/bytes2human.sh"

# Show homepage
# --------------------------------------------------------------
if [[ "${GETpage}" == "main" && "${GETsection}" == "start" ]]; then
	[ -z "${GETpath}" ] && GETpath="${app_logfile_dir}"

	echo '
	<div class="row my-2 mx-1">'
		# Left column - folder structure
		# ------------------------------------------------------
		echo '
		<div class="col-4">
			<div class="card border-0 mb-3">'
				rootdir "${GETpath}" 
				echo '
			</div>
		</div>
		<!-- col -->'

		# Right column - Search form
		# ------------------------------------------------------
		echo '
		<div class="col-8 ps-1">'
			# Format date and time
			day_now=$(date +%d)
			month_now=$(date +%m)
			year_now=$(date +%Y)
			hour_now=$(date +%H)
			minute_now=$(date +%M)
			echo '
			<div class="card border-0 mb-3">
				<div class="card-header border-0">
					<span class="text-secondary"><strong>'${txtSearch}'&nbsp;&nbsp;</strong>'
						GETfile=$(urldecode ${GETfile})
						if [ -f "${GETfile}" ]; then
							if [ ! -w "${GETfile}" ]; then 
								echo '<i class="bi bi-file-earmark-font text-warning align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETfile}''
							else
								echo '<i class="bi bi-file-earmark-font text-success align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETfile}''
							fi
						else
							echo '<i class="bi bi-folder-fill text-secundary align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETpath}''
						fi
						echo '
					</span>
					<i id="load_loading" class="spinner-border text-secondary mt-1 ms-2" style="width: 1rem; height: 1rem;" role="status">
						<span class="visually-hidden">Loading...</span>
					</i>
				</div>
				<div class="card-body pb-0">
					<div class="form-group px-4 mb-3">'
						echo -n '<input type="text" class="form-control form-control-sm" name="searchstring" value='; \
							[ -n "${POSTsearchstring}" ] && echo -n '"'${POSTsearchstring}'" />' || echo -n '"" placeholder="'${txtSearchingFor}'" />'
						echo '
					</div>
					<div class="row px-4 mb-3">
						<div class="form-group col-md-12">
							<div class="form-check">'
								echo -n '<input type="checkbox" class="form-check-input" id="casesensitive_check" name="casesensitive"'; \
									[[ "${POSTcasesensitive}" == "on" ]] && echo -n ' checked />' || echo -n ' />'
								echo '<label for="casesensitive_check" class="form-check-label text-secondary">'${txtCaseSensitive}'</label>
							</div>
						</div>
					</div>
					<!-- row -->
					<div class="row px-4 mb-3">
						<div class="form-group col-md-5">
							<div class="form-check">'
								echo -n '<input type="checkbox" class="form-check-input" id="date_check" name="date"'; \
									[[ "${POSTdate}" == "on" ]] && echo -n ' checked />' || echo -n ' />'
								echo '<label for="date_check" class="form-check-label text-secondary">'${txtUseDate}'</label>
							</div>
						</div>
						<div class="form-group col-md-2">
							<select id="day" name="day" class="form-select form-select-sm">'
								for i in {01..31}; do
									if [[ "${i}" == "${POSTday}" ]]; then
										echo '<option value="'${POSTday}'" selected>'${POSTday}'</option>'
									elif [ -z "${POSTday}" ] && [[ "${i}" == "${day_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
						<div class="form-group col-md-2">
							<select id="month" name="month" class="form-select form-select-sm">'
								for i in {01..12}; do
									if [[ "${i}" == "${POSTmonth}" ]]; then
										echo '<option value="'${POSTmonth}'" selected>'${POSTmonth}'</option>'
									elif [ -z "${POSTmonth}" ] && [[ "${i}" == "${month_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
						<div class="form-group col-md-3">
							<select id="year" name="year" class="form-select form-select-sm">'
								for i in {2010..2040}; do
									if [[ "${i}" == "${POSTyear}" ]]; then
										echo '<option value="'${POSTyear}'" selected>'${POSTyear}'</option>'
									elif [ -z "${POSTyear}" ] && [[ "${i}" == "${year_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
					</div>
					<!-- row -->
					<div class="row px-4 mb-3">
						<div class="form-group col-md-8">
							<div class="form-check">'
								echo -n '<input type="checkbox" class="form-check-input" id="time_check" name="time"'; \
									[[ "${POSTtime}" == "on" ]] && echo -n ' checked />' || echo -n ' />'
								echo '<label for="time_check" class="form-check-label text-secondary">'${txtUseTime}'</label>
							</div>
						</div>
						<div class="form-group col-md-2">
							<select id="hour" name="hour" class="form-select form-select-sm">'
								for i in {01..24}; do
									if [[ "${i}" == "${POSThour}" ]]; then
										echo '<option value="'${POSThour}'" selected>'${POSThour}'</option>'
									elif [ -z "${POSThour}" ] && [[ "${i}" == "${hour_now}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'</option>'
									else
										echo '<option value="'${i}'">'${i}'</option>'
									fi
								done
								echo '
							</select>
						</div>
						<div class="form-group col-md-2">
							<select id="minute" name="minute" class="form-select form-select-sm">'
								if [[ "---" == "${POSTminute}" ]]; then
									echo '<option value="---" selected>---</option>'
								else
									echo '<option value="---">---</option>'
								fi
								for i in {0..5}; do
									if [[ "${i}" == "${POSTminute}" ]]; then
										echo '<option value="'${i}'" selected>'${i}'x</option>'
									else
										echo '<option value="'${i}'">'${i}'x</option>'
									fi
								done
								echo '
							</select>
						</div>
					</div>
					<!-- row -->

					<p class="text-center">'
						if [ -f "${GETfile}" ]; then
							echo '
							<input type="hidden" name="path" value="'${GETpath}'">
							<input type="hidden" name="searchfile" value="'${GETfile}'">'
						else
							echo '<input type="hidden" name="searchpath" value="'${GETpath}'">'
						fi
						echo '
						<input type="hidden" name="query" value="search">
						<button class="btn btn-secondary btn-sm" type="submit" name="formular" value="execute">'$btnStartSearching'</button>
					</p>
				</div>
				<!-- card-body -->
			</div>
			<!-- card -->'

			# Display help as long as no operation is active
			# --------------------------------------------------
			if [[ -z "${POSTformular}" ]] && [[ "${GETquery}" != "view" ]] && [[ "${GETquery}" != "clear" ]]; then
				echo '
				<div class="card border-0 mb-3">
					<div class="card-header border-0">
						<span class="text-secondary">'${txtHelpHeader}'
						</span>
					</div>
					<div class="card-body pb-0">'

						# Help: Explanation of symbols
						# --------------------------------------
						echo '
						<ul style="list-style-type: none">
							<li><span class="text-secondary pe-1">
									<i class="bi bi-house-door text-secondary" style="font-size: 1.3rem;"></i>
									<small>'${txtBtnReset}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-folder-fill text-warning" style="font-size: 1.3rem;"></i>
									<small>'${txtFolderWithContent}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-folder text-warning" style="font-size: 1.3rem;"></i>
									<small>'${txtFolderWithoutContent}'</small>
								</span>
							</li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-font text-success" style="font-size: 1.3rem;"></i>
									<small>'${txtFileOpen}'</small>
								</span>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-font text-warning" style="font-size: 1.3rem;"></i>
									<small>'${txtFileNoWritingRights}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-x text-danger" style="font-size: 1.3rem;"></i>
									<small>'${txtFileNoReadingRights}'</small>
								</span>
							</li>
							<li>
								<span class="text-secondary pe-1">
									<i class="bi bi-file-earmark-zip text-danger" style="font-size: 1.3rem;"></i>
									<small>'${txtFileIsArchive}'</small>
								</span>
							</li>
						</ul>
					</div>
					<!-- card-body -->
				</div>
				<!-- card -->'
			fi

			# Evaluate and display form data
			# --------------------------------------------------
			if [[ "${POSTquery}" == "search" ]] && [[ "${POSTformular}" == "execute" ]]; then
				[ -f "${post_request}" ] && rm "${post_request}"
				setkeyvalue "POSTsearchstring" "${POSTsearchstring}" "${post_request}"

				# Delete existing log file
				[ -f "${search_result}" ] && rm "${search_result}"

				# Create a new log file and set the corresponding rights
				if [ ! -f "${search_result}" ]; then
					touch "${search_result}"
					chmod a+rx "${search_result}"
				fi

				if [ -f "${POSTsearchfile}" ]; then
					PathOrFile=${POSTsearchfile}
					setkeyvalue "GETpath" "${POSTpath}" "${get_request}"
					setkeyvalue "GETfile" "${POSTsearchfile}" "${get_request}"
				else
					PathOrFile=${POSTsearchpath}
					setkeyvalue "GETpath" "${POSTsearchpath}" "${get_request}"
					setkeyvalue "GETfile" "" "${get_request}"
				fi

				if [[ "${POSTcasesensitive}" == "on" ]]; then
					GrepOptions="-EnH"
				else
					GrepOptions="-EnHi"
				fi

				# Evaluate the checkbox states...
				if [ -z "${POSTtime}" ] && [ -z "${POSTdate}" ]; then
					# Date and time are NOT used
					find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*(.*'"${POSTsearchstring}"').*' {} \; >> ${search_result}
				fi

				if [ -z "${POSTdate}" ] && [[ "${POSTtime}" == "on" ]]; then
					# Time is used
					if [[ "${POSTminute}" == "---" ]]; then
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${POSThour}':.{2}:.{2}.*'"${POSTsearchstring}"').*' {} \; >> ${search_result}
					else
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${POSThour}':'${POSTminute}'.{1}:.{2}.*'"${POSTsearchstring}"').*' {} \; >> ${search_result}
					fi
				fi

				if [[ "${POSTdate}" == "on" ]] && [ -z "${POSTtime}" ]; then
					# Date is used
					find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${POSTyear}'.?'${POSTmonth}'.?'${POSTday}'.*'"${POSTsearchstring}"').*' {} \; >> ${search_result}
				fi

				if [[ "${POSTdate}" == "on" ]] && [[ "${POSTtime}" == "on" ]]; then
					# Date and time are used
					if [[ "${POSTminute}" == "---" ]]; then
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${POSTyear}'.?'${POSTmonth}'.?'${POSTday}'.?'${POSThour}':.{2}:.{2}.*'"${POSTsearchstring}"').*' {} \; >> ${search_result}
					else
						find -L "${PathOrFile}" -type f -exec grep "${GrepOptions}" '.*('${POSTyear}'.?'${POSTmonth}'.?'${POSTday}'.?'${POSThour}':'${POSTminute}'.{1}:.{2}.*'"${POSTsearchstring}"').*' {} \; >> ${search_result}
					fi
				fi

				if [ -f "${search_result}" ]; then
					# Output search result
					echo '
					<div class="card border-0">
						<div class="card-header border-0">
							<span class="text-secondary"><strong>'${txtSearchsearch_result}'&nbsp;&nbsp;</strong>'
								if [ -z "${GETfile}" ]; then
									echo '<i class="bi bi-folder-fill text-secundary align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETpath}''
								else
									if [ -f "${GETfile}" ]; then
										if [ ! -w "${GETfile}" ]; then 
											echo '<i class="bi bi-file-earmark-font text-warning align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETfile}''
										else
											echo '<i class="bi bi-file-earmark-font text-success align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETfile}''
										fi
									fi
								fi
								if [ -s "${search_result}" ]; then
									echo '
									<a class="float-end" href="index.cgi?page=main&section=start&query=view&file='${GETfile}'" title="'${btnClose}'">
										<i class="bi bi-x-lg text-secondary align-middle float-end pe-1" style="font-size: 1.3rem;"></i>
									</a>
									<a href="index.cgi?page=contentview&path='${GETpath}'&file='${GETfile}'&search_resultfile='${search_result}'" onclick="return popup(this,992,600)" title="'${txtWhitoutLineBreaks}'">
										<i class="bi bi-card-text text-secondary align-middle float-end pe-3" style="font-size: 1.3rem;"></i>
									</a>
									<a class="float-end" href="temp/search_result.txt" title="Download" download >
										<i class="bi bi-cloud-arrow-down text-secondary align-middle float-end pe-3" style="font-size: 1.3rem;"></i>
									</a>'
								fi
								echo '
							</span>
						</div>
						<div class="card-body px-1 py-1">
							<div id="file-content-box" class="form-group">
								<textarea id="file-content-txt" spellcheck="false" class="form-control border-white bg-white text-monospace" style="font-size: 80%;" rows="13" readonly>'
									if [ -s "${search_result}" ]; then
										while read line; do
											IFS=: read source row hit <<< "${line}"
											if [[ "${GETquery}" == "view" ]]; then	# Search results from a selected file
												echo ''${txtHitInLine}' '${row}'...'
												echo -e -n ''${hit}''
											elif [ -z "${GETquery}" ]; then			# Search results from all files
												IFS=: read source row hit <<< "${line}"
												echo ''${txtHitIn}' '${source}' '${txtLine}' '${row}'...'
												echo -e -n ''${hit}''
											fi
											IFS="${backupIFS}"
											echo '&#13;&#10;'
										done < "${search_result}"
										unset line
									else
										echo ''${txtNoMatches}''
									fi
									echo '
								</textarea>
							</div>
						</div>
						<!-- card-body -->
					</div>
					<!-- card -->'
				fi
			fi
			# Output file content
			# --------------------------------------------------
			if [[ "${GETquery}" == "view" ]] && [ -z "${POSTformular}" ]; then
				# Link back to overview
				if [ -f "${GETfile}" ]; then
					#[ -f "${get_request}" ] && rm "${get_request}"
					# Output file content as a whole
					echo '
					<div class="card border-0">
						<div class="card-header border-0">
							<span class="text-secondary"><strong>'${txtFileContent}'&nbsp;&nbsp;</strong>'
								if [ -f "${GETfile}" ]; then
									if [ ! -w "${GETfile}" ]; then 
										echo '<i class="bi bi-file-earmark-font text-warning align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETfile}''
									else
										echo '<i class="bi bi-file-earmark-font text-success align-middle" style="font-size: 1.3rem;"></i>&nbsp;&nbsp;'${GETfile}''
									fi
								fi
								if [ -s "${GETfile}" ]; then
									if [ -w "${GETfile}" ]; then
										echo '
										<a href="index.cgi?page=main&section=start&query=clear&path='${GETpath}'&file='${GETfile}'" title="'${txtDeleteFileContent}'">
											<i class="bi bi-file-earmark-x text-secondary align-middle float-end pe-1" style="font-size: 1.3rem;"></i>
										</a>'
									fi
									echo '
									<a href="index.cgi?page=contentview&search_resultfile='${GETfile}'" onclick="return popup(this,992,600)" title="'${txtWhitoutLineBreaks}'">
										<i class="bi bi-card-text text-secondary align-middle float-end pe-3" style="font-size: 1.3rem;"></i>
									</a>'
								fi
								echo '
							</span>
						</div>
						<div class="card-body px-0 py-1">
							<div id="file-content-box" class="form-group">
								<textarea id="file-content-txt" spellcheck="false" class="form-control border-white bg-white text-monospace" style="font-size: 80%;" rows="13" readonly>'
									if [ -s "${GETfile}" ]; then
										while read line; do
											echo -e -n ''${line}'&#13;&#10;'
										done < "${GETfile}"
										unset line
									else
										echo ''${txtFileIsEmpty}''
									fi
									echo '
								</textarea>
							</div>
						</div>
						<!-- card-body -->
					</div>
					<!-- card -->'
				fi
			fi

			# Delete file content
			# --------------------------------------------------
			if [[ "${GETquery}" == "clear" ]] && [ -z "${POSTformular}" ]; then

				if [ -z "${GETexecute}" ]; then
					[ -f "${get_request}" ] && rm "${get_request}"
					# Show pop-up window
					popupbox "30" "${txtAlertInputConfirmation}" "${txtAlertClearEntry}" "<a href=\"index.cgi?page=main&section=start&query=clear&execute=yes&path=${GETpath}&file=${GETfile}\" class=\"btn btn-secondary btn-sm\">${btnDeleteNow}</a>&nbsp;&nbsp;&nbsp;<a href=\"index.cgi?page=main&section=start&query=view&path=${GETpath}&file=${GETfile}\" class=\"btn btn-secondary btn-sm\">${btnCancel}</a>"
				fi

				if [[ "${GETexecute}" == "yes" ]] && [ -f "${GETfile}" ]; then
					[ -f "${get_request}" ] && rm "${get_request}"
					:> "${GETfile}"
					echo '<meta http-equiv="refresh" content="0; url=index.cgi?page=main&section=start&query=view&path='${GETpath}'&file='${GETfile}'">'
				else
					# Show pop-up window - Errors during processing
					popupbox "30" "${txtAlertSystemError}" "${txtAlertProcessingError}" "<a href=\"index.cgi?page=main&section=start&query=view&path=${GETpath}&file=${GETfile}\" class=\"btn btn-secondary btn-sm\">${btnUnderstood}</a>"
				fi
			fi
			echo '
		</div>
		<!-- col -->
	</div>
	<!-- row -->'
fi

echo '
<script>
	$("#contentview").show();
</script>'
