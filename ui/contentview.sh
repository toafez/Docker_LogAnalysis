#!/bin/bash
# Filename: contentview.sh - coded in utf-8

#                LogAnalysis für Docker
#    Copyright (C) 2025 by toafez (Tommes) | MIT License


# Display file content without line break
# --------------------------------------------------------------
echo '
<div class="row">
	<div class="col">'
		GETresultfile=$(urldecode ${GETresultfile})
		GETfile=$(urldecode ${GETfile})
		if [ -f "${GETresultfile}" ]; then
			if [[ "${GETresultfile}" == *result.txt ]]; then
				# Output search result
				if [ -z "${GETfile}" ]; then
					echo '<h5>'${txtSearchResultFolder}' '${GETpath}'</h5>'
				else
					echo '<h5>'${txtSearchResultFile}' '${GETfile}'</h5>'
				fi
				echo '
				<div class="text-monospace text-nowrap" style="font-size: 87.5%;">'
					while read line; do
						IFS=: read source row hit <<< "${line}"
						if [[ "${GETquery}" == "view" ]]; then
							# Search results from a selected file
							echo ''${txtHitInLine}' '${row}' ->'
							echo -e -n ''${hit}'<br />'
						elif [ -z "${GETquery}" ]; then
							# Search results from all files
							IFS=: read source row hit <<< "${line}"
							echo ''${txtHitIn}' '${source}' '${txtLine}' '${row}' ->'
							echo -e -n ''${hit}'<br />'
						fi
					done < "${GETresultfile}"
					unset source row hit
					IFS="${backupIFS}"
					echo '
				</div>'
			elif [[ "${GETresultfile}" == "${app_work_dir}"* ]]; then
				# Output file content
				echo '
				<h5>'${txtViewFile}' '${GETfile}'</h5>
				<div class="text-monospace text-nowrap" style="font-size: 87.5%;">'
					row=1
					while read line; do
						echo ''${txtLine}' '${row}' -> '${line}'<br>'
						row=$[${row}+1]
					done < "${GETresultfile}"
					unset counter
					echo '
				</div>'
			else
				echo '
				<h5>'${txtAlertSystemError}'</h5>
				'${txtAlertAccessDenied_step1}' <strong class="text-danger">'${GETresultfile}'</strong> '${txtAlertAccessDenied_step2}''
			fi
			unset line
		else
			echo '
			<h5>'${txtAlertSystemError}' '${GETresultfile}'</h5>
			'${txtAlertProcessingError}''
		fi
		echo '
	</div>
	<!-- col -->
</div>
<!-- row -->'
